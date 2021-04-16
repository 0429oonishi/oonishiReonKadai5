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
    private let viewModel: CalculateViewModelType = CalculateViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }

    private func setupBindings() {
        viewModel.outputs.calculatedText
            .drive(resultLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.event
            .drive(onNext: { [weak self] in
                switch $0 {
                case let .showAlert(message):
                    self?.showAlert(message: message)
                }
            })
            .disposed(by: disposeBag)
    }

    @IBAction func didTapCalculateButton(_ sender: Any) {
        viewModel.inputs.didTapCalculateButton(
            numberToBeDivideText: numberToBeDivideTextField.text,
            numberToDivideText: numberToDivideTextField.text
        )
    }
}

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

    func didTapCalculateButton(numberToBeDivideText: String?, numberToDivideText: String?) {
        guard let numberToBeDivideText = numberToBeDivideText else { return }
        guard let numberToDivideText = numberToDivideText else { return }

        guard !numberToBeDivideText.isEmpty else {
            eventRelay.accept(.showAlert(CalculateErrorMessage.invalidNumberToBeDivide))
            return
        }

        guard !numberToDivideText.isEmpty else {
            eventRelay.accept(.showAlert(CalculateErrorMessage.invalidNumberToDivide))
            return
        }

        guard let numberToBeDivideNum = Double(numberToBeDivideText),
              let numberToDivideNum = Double(numberToDivideText) else { return }

        switch Calculator().divide(numberToBeDivideNum: numberToBeDivideNum, numberToDivideNum: numberToDivideNum) {
        case let .success(result):
            calculatedTextRelay.accept(String(result))
        case let .failure(error):
            switch error {
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

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "課題5", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

private class Calculator {
    enum Error: Swift.Error {
        case numberToDivideIsZero
    }

    func divide(numberToBeDivideNum: Double, numberToDivideNum: Double) -> Result<Double, Error> {
        guard !numberToDivideNum.isZero else {
            return .failure(.numberToDivideIsZero)
        }

        return .success(numberToBeDivideNum / numberToDivideNum)
    }
}
