//
//  AddEmployeeViewController.swift
//  CESDemo
//
//  Created by Pratik Sakhare on 13/10/22.
//

import UIKit
import RxCocoa
import RxSwift
import Toast_Swift

class AddEmployeeViewController: UIViewController {

    // Outlets
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    
    // Properties
    private var disposeBag = DisposeBag()
    private var addEmployeeViewModel = AddEmployeeViewModel()
    var selectedEmployee: Employee?
    
    // Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButtonSubscribers()
        self.handleUpdateEmployee()
        self.addTextFieldSubscribers()
    }
    
    private func addButtonSubscribers() {
        self.onClickOfAddButton()
    }
    
    private func addTextFieldSubscribers() {
        nameTextField.rx.text.bind(to: self.addEmployeeViewModel.nameSubject).disposed(by: disposeBag)
        departmentTextField.rx.text.bind(to: self.addEmployeeViewModel.departmentSubject).disposed(by: disposeBag)
    }
    
    private func handleUpdateEmployee() {
        let buttonTitle = selectedEmployee == nil ? "Add" : "Update"
        addButton.setTitle(buttonTitle, for: .normal)
        if selectedEmployee != nil {
            nameTextField.text = selectedEmployee?.name ?? ""
            departmentTextField.text = selectedEmployee?.department ?? ""
        }
    }

    private func onClickOfAddButton() {
        addButton.rx.tap.bind { [weak self] in
            let tuple = self?.addEmployeeViewModel.validateAddEmployeeForm()
            if (tuple?.success ?? false) {
                if self?.selectedEmployee == nil {
                    self?.addEmployeeData()
                } else {
                    self?.updateEmployeeData()
                }
            } else {
                switch tuple?.errorType {
                case "field_validation":
                    self?.view.makeToast("Please fill all the fields")
                default:
                    break
                }
            }

        }
        .disposed(by: disposeBag)
    }

    private func addEmployeeData() {
        self.addEmployeeViewModel.saveEmployeeData().asObservable().subscribe(onNext: { success in
            if success {
                self.view.makeToast("Employee added successfully.")
                self.dismiss(animated: true)
            }
        }, onError: { error in
            self.view.makeToast("Something went worng. Please try agagin.")
        }).disposed(by: self.disposeBag)
    }
    
    private func updateEmployeeData() {
        if let selectedEmployee = selectedEmployee {
            self.addEmployeeViewModel.updateEmployeeData(selectedEmployee: selectedEmployee).asObservable().subscribe(onNext: { success in
                if success {
                    self.view.makeToast("Employee updated successfully.")
                    self.dismiss(animated: true)
                }
            }, onError: { error in
                self.view.makeToast("Something went worng. Please try agagin.")
            }).disposed(by: self.disposeBag)
        }
    }
}
