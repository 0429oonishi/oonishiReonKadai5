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

    // 具体的なUseCaseを注入する
    private let viewModel: CalculateViewModelType = CalculateViewModel(
        calculateUseCase: CalculateUseCase()
    )
    
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

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "課題5", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
