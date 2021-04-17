//
//  CalculateUseCase.swift
//  oonishiReonKadai5
//
//  Created by akio0911 on 2021/04/17.
//

import Foundation
import RxSwift
import RxRelay

enum CalculateUseCaseError: Swift.Error {
    case numberToBeDivideTextIsNil
    case numberToDivideTextIsNil
    case numberToBeDivideTextIsEmpty
    case numberToDivideTextIsEmpty
    case numberToBeDivideNumIsNotNumber
    case numberToDivideNumIsNotNumber
    case numberToDivideIsZero
}

// アプリケーションのロジック。
// View などの事情を知らず、依存もしていない。
// SwiftUI・コンソールアプリ・Webアプリなどでも使用できる。
final class CalculateUseCase: CalculateUseCaseProtocol {
    func calculate(numberToBeDivideText: String?, numberToDivideText: String?) -> Result<Double, CalculateUseCaseError> {
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
