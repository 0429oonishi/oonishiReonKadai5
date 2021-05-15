//
//  CalculatorViewModel.swift
//  oonishiReonKadai5
//
//  Created by 大西玲音 on 2021/04/17.
//

import RxSwift
import RxCocoa

protocol CalculateViewModelInput {
    func calculateButtonDidTapped(numberToBeDivideText: String?, numberToDivideText: String?)
}

protocol CalculateViewModelOutput {
    var calculatedText: Driver<String> { get }
    var event: Driver<CalculateViewModel.Event> { get }
}

protocol CalculateViewModelType {
    var inputs: CalculateViewModelInput { get }
    var outputs: CalculateViewModelOutput { get }
}

class CalculateViewModel: CalculateViewModelInput, CalculateViewModelOutput {
    enum Event {
        case showAlert(String)
    }
    let calculatedText: Driver<String>
    private let calculatedTextRelay = BehaviorRelay<String>(value: "")
    let event: Driver<Event>
    private let eventRelay = PublishRelay<Event>()
    init() {
        calculatedText = calculatedTextRelay.asDriver()
        event = eventRelay.asDriver(onErrorDriveWith: .empty())
    }
    func calculateButtonDidTapped(numberToBeDivideText: String?, numberToDivideText: String?) {
        guard let numberToBeDivideText = numberToBeDivideText else { return }
        guard let numberToDivideText = numberToDivideText else { return }
        guard !numberToBeDivideText.isEmpty else {
            eventRelay.accept(.showAlert(CalculatorErrorMessage.invalidNumberToBeDivide))
            return
        }
        guard !numberToDivideText.isEmpty else {
            eventRelay.accept(.showAlert(CalculatorErrorMessage.invalidNumberToDivide))
            return
        }
        guard let numberToBeDivideNum = Double(numberToBeDivideText),
              let numberToDivideNum = Double(numberToDivideText) else { return }
        
        switch Calculator().divide(numberToBeDivideNum: numberToBeDivideNum, numberToDivideNum: numberToDivideNum) {
        case .success(let result):
            calculatedTextRelay.accept(String(result))
        case .failure(let error):
            switch error {
            case .numberToDivideIsZero:
            eventRelay.accept(.showAlert(CalculatorErrorMessage.numberToDivideIsZero))
            }
        }
        
        guard !numberToDivideNum.isZero else {
            eventRelay.accept(.showAlert(CalculatorErrorMessage.numberToDivideIsZero))
            return
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
