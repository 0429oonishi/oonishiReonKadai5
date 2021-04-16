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

protocol ViewModelInput {
    func didTapCalculateButton(numberToBeDivideText: String?, numberToDivideText: String?)
}

protocol ViewModelOutput {
    var calculatedText: Driver<String> { get }
    var event: Driver<ViewModel.Event> { get }
}

protocol ViewModelType {
    var inputs: ViewModelInput { get }
    var outputs: ViewModelOutput { get }
}

class ViewModel: ViewModelInput, ViewModelOutput {
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

        guard !numberToDivideNum.isZero else {
            eventRelay.accept(.showAlert(CalculateErrorMessage.numberToDivideIsZero))
            return
        }

        calculatedTextRelay.accept(String(numberToBeDivideNum / numberToDivideNum))
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
