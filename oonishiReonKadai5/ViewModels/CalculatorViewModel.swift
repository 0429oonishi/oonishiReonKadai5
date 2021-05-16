//
//  CalculatorViewModel.swift
//  oonishiReonKadai5
//
//  Created by 大西玲音 on 2021/04/17.
//

import RxSwift
import RxCocoa

protocol CalculateViewModelInput {
    func calculateButtonDidTapped(numberToBeDivideText: String?,
                                  numberToDivideText: String?)
}

protocol CalculateViewModelOutput {
    var calculatedText: Driver<String> { get }
    var event: Driver<CalculateViewModel.Event> { get }
}

protocol CalculateViewModelType {
    var inputs: CalculateViewModelInput { get }
    var outputs: CalculateViewModelOutput { get }
}

class CalculateViewModel: CalculateViewModelInput,
                          CalculateViewModelOutput {
    enum Event {
        case showAlert(String)
    }
    // Driverでメインスレッドでの実行保証
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
    
    func calculateButtonDidTapped(numberToBeDivideText: String?,
                                  numberToDivideText: String?) {
        // 具体的な処理は、UseCaseに任せる
        let result = calculateUseCase.calculate(
            numberToBeDivideText: numberToBeDivideText,
            numberToDivideText: numberToDivideText
        )
        
        // UseCaseからの出力を適切に変換し、ViewへのBindingをするための出力
        switch result {
            case .success(let value):
                calculatedTextRelay.accept(String(value))
            case .failure(let error):
                switch error {
                    case .numberToBeDivideTextIsNil,
                         .numberToDivideTextIsNil,
                         .numberToDivideNumIsNotNumber,
                         .numberToBeDivideNumIsNotNumber:
                        break
                    case .numberToBeDivideTextIsEmpty:
                        eventRelay.accept(.showAlert(CalculatorErrorMessage.invalidNumberToBeDivide))
                    case .numberToDivideTextIsEmpty:
                        eventRelay.accept(.showAlert(CalculatorErrorMessage.invalidNumberToDivide))
                    case .numberToDivideIsZero:
                        eventRelay.accept(.showAlert(CalculatorErrorMessage.numberToDivideIsZero))
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

private enum CalculatorErrorMessage {
    static let invalidNumberToBeDivide = "割られる数を入力してください。"
    static let invalidNumberToDivide = "割る数を入力してください。"
    static let numberToDivideIsZero = "割る数には０を入力しないでください。"
}


