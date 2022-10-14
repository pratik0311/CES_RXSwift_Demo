//
//  LoginViewController.swift
//  CESDemo
//
//  Created by Pratik Sakhare on 12/10/22.
//

import UIKit
import RxCocoa
import RxSwift
import Toast_Swift

class LoginViewController: UIViewController {

    // Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Properties
    private var disposeBag = DisposeBag()
    private var loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButtonSubscribers()
        self.addTextFieldSubscribers()
    }
    
    private func addButtonSubscribers() {
        self.onClickOfLoginButton()
    }
    
    private func addTextFieldSubscribers() {
        nameTextField.rx.text.bind(to: self.loginViewModel.nameSubject).disposed(by: disposeBag)
        passwordTextField.rx.text.bind(to: self.loginViewModel.passwordSubject).disposed(by: disposeBag)
    }

    private func onClickOfLoginButton() {
        loginButton.rx.tap.bind { [weak self] in
            let tuple = self?.loginViewModel.validateLoginForm()
            if (tuple?.success ?? false) {
                let companyName = self?.nameTextField.text
                // Store logged in company name for future reference
                UserDefaults.standard.set(companyName, forKey: "loggedIn_company")
                self?.navigateToEmployeeListScreen()
            } else {
                switch tuple?.errorType {
                case "field_validation":
                    self?.view.makeToast("Please fill all the fields")
                case "company_not_exist":
                    self?.view.makeToast("This company does not exist.")
                case "wrong_password":
                    self?.view.makeToast("Please enter correct passowrd.")
                default:
                    break
                }
            }

        }
        .disposed(by: disposeBag)
    }
    
    private func navigateToEmployeeListScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let employeeListViewController = storyboard.instantiateViewController(identifier: "EmployeeListViewController")
        
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(employeeListViewController)
    }
}
