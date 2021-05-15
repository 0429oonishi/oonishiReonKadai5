import UIKit
import RxSwift
import RxCocoa
import PlaygroundSupport

enum CalculateError: Error {
    case numberToDivideIsZero
}
func calculate(num1: Double, num2: Double) -> Result<Double, CalculateError> {
    if num2.isZero {
        return .failure(.numberToDivideIsZero)
    }
    return .success(num1 / num2)
}

let num1 = 10.0
let num2 = 0.0
switch calculate(num1: num1, num2: num2) {
    case .success(let result):
        print(result)
    case .failure(let error):
        print(error)
}
