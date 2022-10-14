//
//  RegistrationViewController.swift
//  CESDemo
//
//  Created by Pratik Sakhare on 12/10/22.
//

import UIKit
import RxCocoa
import RxSwift
import Toast_Swift

class RegistrationViewController: UIViewController {

    // Outlets
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Properties
    private var disposeBag = DisposeBag()
    private var registrationViewModel = RegistrationViewModel()
    
    // Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButtonSubscribers()
        self.addTextFieldSubscribers()
    }
    
    private func addButtonSubscribers() {
        self.onClickOfRegisterButton()
    }
    
    private func addTextFieldSubscribers() {
        nameTextField.rx.text.bind(to: self.registrationViewModel.nameSubject).disposed(by: disposeBag)
        locationTextField.rx.text.bind(to: self.registrationViewModel.locationSubject).disposed(by: disposeBag)
        passwordTextField.rx.text.bind(to: self.registrationViewModel.passwordSubject).disposed(by: disposeBag)
    }
    
    private func onClickOfRegisterButton() {
        registerButton.rx.tap.bind { [weak self] in
            let tuple = self?.registrationViewModel.validateRegistrationForm()
            if (tuple?.success ?? false) {
                self?.registrationViewModel.saveCompanyDataToFile().asObservable().subscribe(onNext: { success in
                    if success {
                        self?.view.makeToast("Registertration successful, please login.")
                        self?.navigationController?.popViewController(animated: true)
                    }
                }, onError: { error in
                    self?.view.makeToast("Something went worng. Please try agagin.")
                }).disposed(by: self?.disposeBag ?? DisposeBag())
            } else {
                switch tuple?.errorType {
                case "field_validation":
                    self?.view.makeToast("Please fill all the fields")
                case "company_exist":
                    self?.view.makeToast("The company with same name is already exist.")
                default:
                    break
                }
            }
        }
        .disposed(by: disposeBag)
    }
}
