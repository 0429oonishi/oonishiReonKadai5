//
//  CalculateViewController.swift
//  oonishiReonKadai5
//
//  Created by 大西玲音 on 2021/04/15.
//

import UIKit
import RxSwift
import RxCocoa

final class CalculateViewController: UIViewController {
    
    @IBOutlet private weak var numberToBeDivideTextField: UITextField!
    @IBOutlet private weak var numberToDivideTextField: UITextField!
    @IBOutlet private weak var calculateButton: UIButton!
    @IBOutlet private weak var resultLabel: UILabel!
    private let disposeBag = DisposeBag()
    private let viewModel: ViewModelType = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Input
        calculateButton.rx.tap
            .subscribe { _ in
                guard let numberToBeDivideText = self.numberToBeDivideTextField.text else { return }
                guard let numberToDivideText = self.numberToDivideTextField.text else { return }
                guard !numberToBeDivideText.isEmpty else {
                    self.showAlert(message: CalculateErrorMessage.invalidNumberToBeDivide)
                    return
                }
                guard !numberToDivideText.isEmpty else {
                    self.showAlert(message: CalculateErrorMessage.invalidNumberToDivide)
                    return
                }
                guard let numberToBeDivideNum = Double(numberToBeDivideText),
                      let numberToDivideNum = Double(numberToDivideText) else { return }
                guard !numberToDivideNum.isZero else {
                    self.showAlert(message: CalculateErrorMessage.numberToDivideIsZero)
                    return
                }
                self.viewModel.inputs.num.onNext(numberToBeDivideNum / numberToDivideNum)
            }
            .disposed(by: disposeBag)
        
        // MARK: - Output
        viewModel.outputs.calculatedText
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
}

protocol ViewModelInput {
    var num: AnyObserver<Double> { get }
}

protocol ViewModelOutput {
    var calculatedText: Observable<String> { get }
}

protocol ViewModelType {
    var inputs: ViewModelInput { get }
    var outputs: ViewModelOutput { get }
}

class ViewModel: ViewModelInput, ViewModelOutput {
    var num: AnyObserver<Double>
    var calculatedText: Observable<String>
    init() {
        let _calculatedText = PublishRelay<String>()
        self.calculatedText = _calculatedText.asObservable()
        self.num = AnyObserver<Double>() { num in
            let numText = String(num.element!)
            _calculatedText.accept(numText)
        }
    }
}

extension ViewModel: ViewModelType {
    var inputs: ViewModelInput {
        return self
    }
    
    var outputs: ViewModelOutput {
        return self
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


