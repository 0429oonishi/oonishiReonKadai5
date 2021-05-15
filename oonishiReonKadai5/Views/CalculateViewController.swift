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
    private let calculateViewModel: CalculateViewModelType = CalculateViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        
    }
    
    private func setupBindings() {
        calculateViewModel.outputs.calculatedText
            .drive(resultLabel.rx.text)
            .disposed(by: disposeBag)
        
        calculateViewModel.outputs.event
            .drive(onNext: { [weak self] in
                switch $0 {
                case .showAlert(let message):
                    self?.showAlert(message: message)
                }
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func calculateButtonDidTapped(_ sender: Any) {
        calculateViewModel.inputs.calculateButtonDidTapped(
            numberToBeDivideText: numberToBeDivideTextField.text,
            numberToDivideText: numberToDivideTextField.text
        )
    }
    
}

