//
//  CalculateUseCaseError.swift
//  oonishiReonKadai5
//
//  Created by 大西玲音 on 2021/05/16.
//

import Foundation

enum CalculateUseCaseError: Error {
    case numberToBeDivideTextIsNil
    case numberToDivideTextIsNil
    case numberToBeDivideTextIsEmpty
    case numberToDivideTextIsEmpty
    case numberToBeDivideNumIsNotNumber
    case numberToDivideNumIsNotNumber
    case numberToDivideIsZero
}

protocol CalculateUseCaseProtocol {
    func calculate(numberToBeDivideText: String?,
                   numberToDivideText: String?) -> Result<Double, CalculateUseCaseError>
}

// 具体的な処理をするUseCase
final class CalculateUseCase: CalculateUseCaseProtocol {
    func calculate(numberToBeDivideText: String?,
                   numberToDivideText: String?) -> Result<Double, CalculateUseCaseError> {
        guard let numberToBeDivideText = numberToBeDivideText else {
            return .failure(.numberToBeDivideTextIsNil)
        }
        
        guard let numberToDivideText = numberToDivideText else {
            return .failure(.numberToDivideTextIsNil)
        }
        
        guard !numberToBeDivideText.isEmpty else {
            return .failure(.numberToBeDivideTextIsEmpty)
        }
        
        guard !numberToDivideText.isEmpty else {
            return .failure(.numberToDivideTextIsEmpty)
        }
        
        guard let numberToBeDivideNum = Double(numberToBeDivideText) else {
            return .failure(.numberToBeDivideNumIsNotNumber)
        }
        
        guard let numberToDivideNum = Double(numberToDivideText) else {
            return .failure(.numberToDivideNumIsNotNumber)
        }
        
        guard !numberToDivideNum.isZero else {
            return .failure(.numberToDivideIsZero)
        }
        
        return .success(numberToBeDivideNum / numberToDivideNum)
    }
}
