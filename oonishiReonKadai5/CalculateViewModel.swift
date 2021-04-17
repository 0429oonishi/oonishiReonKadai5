//
//  CalculateViewModel.swift
//  oonishiReonKadai5
//
//  Created by akio0911 on 2021/04/17.
//

import Foundation
import RxCocoa

protocol CalculateViewModelInput {
    func didTapCalculateButton(numberToBeDivideText: String?, numberToDivideText: String?)
}

protocol CalculateViewModelOutput {
    var calculatedText: Driver<String> { get }
    var event: Driver<CalculateViewModel.Event> { get }
}

protocol CalculateViewModelType {
    var inputs: CalculateViewModelInput { get }
    var outputs: CalculateViewModelOutput { get }
}

protocol CalculateUseCaseProtocol {
    func calculate(numberToBeDivideText: String?, numberToDivideText: String?) -> Result<Double, CalculateUseCaseError>
}

class CalculateViewModel: CalculateViewModelInput, CalculateViewModelOutput {
    enum Event {
        case showAlert(String)
    }

    let calculatedText: Driver<String>
    private let calculatedTextRelay = BehaviorRelay<String>(value: "")

    let event: Driver<Event>
    private let eventRelay = PublishRelay<Event>()

    // 具体的なUseCase名に依存させず、プロトコルに依存させる
    private let calculateUseCase: CalculateUseCaseProtocol

    init(calculateUseCase: CalculateUseCaseProtocol) {
        calculatedText = calculatedTextRelay.asDriver()
        event = eventRelay.asDriver(onErrorDriveWith: .empty())
        self.calculateUseCase = calculateUseCase
    }

    // ボタン操作の伝達を受け付ける
    func didTapCalculateButton(numberToBeDivideText: String?, numberToDivideText: String?) {
        // 具体的な処理は持たず、UseCaseに任せる
        let result = calculateUseCase.calculate(
            numberToBeDivideText: numberToBeDivideText,
            numberToDivideText: numberToDivideText
        )

        // UseCaseからの出力を適切に変換し、ViewへBindingするための出力を行う
        switch result {
        case let .success(value):
            calculatedTextRelay.accept(String(value))
        case let .failure(error):
            switch error {
            case .numberToBeDivideTextIsNil,
                 .numberToDivideTextIsNil,
                 .numberToBeDivideNumIsNotNumber,
                 .numberToDivideNumIsNotNumber:
                break
            case .numberToBeDivideTextIsEmpty:
                eventRelay.accept(.showAlert(CalculateErrorMessage.invalidNumberToBeDivide))
            case .numberToDivideTextIsEmpty:
                eventRelay.accept(.showAlert(CalculateErrorMessage.invalidNumberToDivide))
            case .numberToDivideIsZero:
                eventRelay.accept(.showAlert(CalculateErrorMessage.numberToDivideIsZero))
            }
        }
    }
}

extension CalculateViewModel: CalculateViewModelType {
    var inputs: CalculateViewModelInput {
        return self
    }

    var outputs: CalculateViewModelOutput {
        return self
    }
}

private enum CalculateErrorMessage {
    static let invalidNumberToBeDivide = "割られる数を入力してください。"
    static let invalidNumberToDivide = "割る数を入力してください。"
    static let numberToDivideIsZero = "割る数には０を入力しないでください。"
}
