//
//  EmployeeListViewController.swift
//  CESDemo
//
//  Created by Pratik Sakhare on 13/10/22.
//

import UIKit
import RxSwift
import RxCocoa

class EmployeeListViewController: UIViewController {

    // Outlets
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var employeeListTableView: UITableView!
    
    // Properties
    private let disposeBag = DisposeBag()
    private let employeeListViewModel = EmployeeListViewModel()
    private let addEmployeeViewModel = AddEmployeeViewModel()
    
    // Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButtonSubscribers()
        self.employeeListViewModel.getEmployeeList()
        self.bindEmployeeListTableView()
        self.tableViewCellSelection()
        self.subscribeAddEmployeeDataSuccess()
    }
    
    private func addButtonSubscribers() {
        self.onClickOfLogoutButton()
    }
    
    private func onClickOfLogoutButton() {
        logoutButton.rx.tap.bind { [weak self] in
            UserDefaults.standard.removeObject(forKey: "loggedIn_company")
            self?.navigateToLoginScreenAfterLogout()
        }
        .disposed(by: disposeBag)
    }
        
    private func navigateToLoginScreenAfterLogout() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
    
    private func bindEmployeeListTableView() {
        employeeListTableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        employeeListViewModel.employees
            .bind(to: employeeListTableView.rx.items(cellIdentifier: "EmployeeListTableViewCell", cellType: EmployeeListTableViewCell.self)) { index, element, cell in
                cell.setCellData(employee: element, index: index)
                cell.markButton.rx.tap.bind { [weak self] in
                    if let markedEmployee = self?.employeeListViewModel.employees.value[cell.markButton.tag] {
                        self?.markEmployeeResigned(markedEmployee: markedEmployee)
                    }
                }
                .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    private func markEmployeeResigned(markedEmployee: Employee) {
        self.employeeListViewModel.markEmployeeResigned(markedEmployee: markedEmployee).asObservable().subscribe(onNext: { [weak self] success in
            if success {
                self?.view.makeToast("Employee marked resigned successfully.")
                self?.employeeListViewModel.employees.accept(self?.employeeListViewModel.employees.value ?? [])
            }
        }, onError: { error in
            self.view.makeToast("Something went worng. Please try agagin.")
        }).disposed(by: self.disposeBag)
    }
    
    private func tableViewCellSelection() {
        employeeListTableView.rx.itemSelected
          .subscribe(onNext: { [weak self] indexPath in
              let selectedEmployee = self?.employeeListViewModel.employees.value[indexPath.row]
              self?.navigateToUpdateEmployeeDataScreen(selectedEmployee: selectedEmployee)
          }).disposed(by: disposeBag)
    }
    
    private func navigateToUpdateEmployeeDataScreen(selectedEmployee: Employee?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addEmployeeViewController = storyboard.instantiateViewController(identifier: "AddEmployeeViewController") as! AddEmployeeViewController
        addEmployeeViewController.selectedEmployee = selectedEmployee
        self.show(addEmployeeViewController, sender: self)
    }
    
    private func subscribeAddEmployeeDataSuccess() {
        addEmployeeViewModel.successObservable.subscribe(onNext: { [weak self] success in
            self?.employeeListViewModel.employees.accept(self?.employeeListViewModel.employees.value ?? [])
        }).disposed(by: disposeBag)
    }
}

extension EmployeeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}
