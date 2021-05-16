//
//  CalculateViewController.swift
//  oonishiReonKadai5
//
//  Created by 大西玲音 on 2021/04/15.
//

import UIKit
import RxSwift

final class CalculateViewController: UIViewController {
    
    @IBOutlet private weak var numberToBeDivideTextField: UITextField!
    @IBOutlet private weak var numberToDivideTextField: UITextField!
    @IBOutlet private weak var calculateButton: UIButton!
    @IBOutlet private weak var resultLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    // 具体的なUseCaseを注入する
    private let calculateViewModel: CalculateViewModelType = CalculateViewModel(
        calculateUseCase: CalculateUseCase()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        
    }
    
    @IBAction private func calculateButtonDidTapped(_ sender: Any) {
        // ボタンがタップされたことを入力値を添えてViewModelに通知
        calculateViewModel.inputs.calculateButtonDidTapped(
            numberToBeDivideText: numberToBeDivideTextField.text,
            numberToDivideText: numberToDivideTextField.text
        )
    }
    
}

// MARK: - setup
private extension CalculateViewController {
    func setupBindings() {
        calculateViewModel.outputs.calculatedText
            .drive(resultLabel.rx.text)
            .disposed(by: disposeBag)
        
        calculateViewModel.outputs.event
            .drive(onNext: { [weak self] event in
                switch event {
                    case .showAlert(let message):
                        // ViewModelからの表示要請に応える
                        self?.showAlert(message: message)
                }
            })
            .disposed(by: disposeBag)
    }
}
