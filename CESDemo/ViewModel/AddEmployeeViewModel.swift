//
//  AddEmployeeViewModel.swift
//  CESDemo
//
//  Created by Pratik Sakhare on 13/10/22.
//

import Foundation
import RxSwift
import RxCocoa

class AddEmployeeViewModel {
    var dataManager = DataManager()
    var nameSubject = BehaviorRelay<String?>(value: "")
    var departmentSubject = BehaviorRelay<String?>(value: "")
    let disposeBag = DisposeBag()
    private let successSubject = PublishSubject<Bool>()
    var successObservable: Observable<Bool> {
        return successSubject.asObservable()
    }

    func validateAddEmployeeForm() -> (success: Bool, errorType: String) {
        guard let name = nameSubject.value, let department = departmentSubject.value, !(name.isEmpty), !(department.isEmpty) else {
            return (success: false, errorType: "field_validation")
        }
        return (success: true, errorType: "")
    }
    
    func saveEmployeeData() -> Observable<Bool> {
        Observable.create({ [weak self] subscriber in
            self?.dataManager.getEmployeeData(fileName: "EmployeeList").subscribe(onNext: { employees in
                var allEmployees = employees
                var newEmployeeList = EmployeeList()
                var employee = Employee()
                employee.id = String(employees.count + 1)
                employee.companyId = UserDefaults.standard.value(forKey: "loggedIn_company") as? String
                employee.name = self?.nameSubject.value
                employee.department = self?.departmentSubject.value
                employee.status = true
                allEmployees.append(employee)
                newEmployeeList.employeeList = allEmployees
                self?.dataManager.addEmployeeData(fileName: "EmployeeList", employeeList: newEmployeeList).asObservable().subscribe(onNext: { [weak self] success in
                    self?.successSubject.onNext(true)
                    subscriber.onNext(success)
                }, onError: subscriber.onError(_:)).disposed(by: self?.disposeBag ?? DisposeBag())
            }).disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        })
    }
    
    func updateEmployeeData(selectedEmployee: Employee) -> Observable<Bool> {
        Observable.create({ [weak self] subscriber in
            self?.dataManager.getEmployeeData(fileName: "EmployeeList").subscribe(onNext: { employees in
                var allEmployees = employees
                let selectedIndex = allEmployees.firstIndex(where: {$0.id == selectedEmployee.id})
                allEmployees.remove(at: selectedIndex ?? 1)
                var newEmployeeList = EmployeeList()
                var employee = selectedEmployee
                employee.id = selectedEmployee.id
                employee.companyId = selectedEmployee.companyId
                employee.name = self?.nameSubject.value
                employee.department = self?.departmentSubject.value
                employee.status = selectedEmployee.status
                allEmployees.insert(employee, at: selectedIndex ?? 1)
                newEmployeeList.employeeList = allEmployees
                self?.dataManager.addEmployeeData(fileName: "EmployeeList", employeeList: newEmployeeList).asObservable().subscribe(onNext: { success in
                    self?.successSubject.onNext(true)
                    subscriber.onNext(success)
                }, onError: subscriber.onError(_:)).disposed(by: self?.disposeBag ?? DisposeBag())
            }).disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        })
    }
}
