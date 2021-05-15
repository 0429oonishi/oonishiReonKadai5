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
    
    init() {
        calculatedText = calculatedTextRelay.asDriver()
        event = eventRelay.asDriver(onErrorDriveWith: .empty())
    }
    
    func calculateButtonDidTapped(numberToBeDivideText: String?,
                                  numberToDivideText: String?) {
        guard let numberToBeDivideText = numberToBeDivideText,
              let numberToDivideText = numberToDivideText else { return }
        
        // Alert表示要求
        guard !numberToBeDivideText.isEmpty else {
            eventRelay.accept(.showAlert(CalculatorErrorMessage.invalidNumberToBeDivide))
            return
        }
        
        // Alert表示要求
        guard !numberToDivideText.isEmpty else {
            eventRelay.accept(.showAlert(CalculatorErrorMessage.invalidNumberToDivide))
            return
        }
        guard let numberToBeDivideNum = Double(numberToBeDivideText),
              let numberToDivideNum = Double(numberToDivideText) else { return }
        
        // ビジネスロジックはModelにやらせる
        switch Calculator().divide(numberToBeDivideNum: numberToBeDivideNum,
                                   numberToDivideNum: numberToDivideNum) {
            case .success(let result):
                // 計算実行通知
                calculatedTextRelay.accept(String(result))
            case .failure(let error):
                switch error {
                    case .numberToDivideIsZero:
                        // Alert表示要求
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


