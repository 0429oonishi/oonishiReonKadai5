//
//  CalculateViewController.swift
//  oonishiReonKadai5
//
//  Created by 大西玲音 on 2021/04/15.
//

import UIKit

final class CalculateViewController: UIViewController {
    
    @IBOutlet private weak var numberToBeDivideTextField: UITextField!
    @IBOutlet private weak var numberToDivideTextField: UITextField!
    @IBOutlet private weak var resultLabel: UILabel!

    
    @IBAction private func calculateButtonDidTapped(_ sender: Any) {
        guard let numberToDivideText = numberToDivideTextField.text else { return }
        guard let numberToBeDivideText = numberToBeDivideTextField.text else { return }
        guard !numberToBeDivideText.isEmpty else {
            showAlert(message: CalculateErrorMessage.invalidNumberToBeDivide)
            return
        }
        guard !numberToDivideText.isEmpty else {
            showAlert(message: CalculateErrorMessage.invalidNumberToDivide)
            return
        }
        guard let numberToBeDivideNum = Double(numberToBeDivideText),
              let numberToDivideNum = Double(numberToDivideText) else { return }
        guard !numberToBeDivideNum.isZero else {
            showAlert(message: CalculateErrorMessage.numberToDivideIsZero)
            return
        }
        resultLabel.text = String(numberToBeDivideNum / numberToDivideNum)
    }
    
}

enum CalculateErrorMessage {
    static let invalidNumberToBeDivide = "割られる数を入力してください。"
    static let invalidNumberToDivide = "割る数を入力してください。"
    static let numberToDivideIsZero = "割る数には０を入力しないでください。"
}

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "課題5", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


