//
//  EmployeeListViewModel.swift
//  CESDemo
//
//  Created by Pratik Sakhare on 13/10/22.
//

import Foundation
import RxSwift
import RxCocoa

class EmployeeListViewModel {
    var dataManager = DataManager()
    let disposeBag = DisposeBag()
    var employees = BehaviorRelay<[Employee]>(value: [])
    
    func getEmployeeList() {
        if let companyId = UserDefaults.standard.value(forKey: "loggedIn_company") as? String {
            self.dataManager.getEmployeeData(fileName: "EmployeeList").subscribe { [weak self] employeeLists in
                let filteredEmployees = employeeLists.element?.filter({$0.companyId == companyId})
                self?.employees = BehaviorRelay<[Employee]>(value: filteredEmployees ?? [])
            }.disposed(by: disposeBag)
        }
    }
    
    func markEmployeeResigned(markedEmployee: Employee) -> Observable<Bool> {
        Observable.create({ [weak self] subscriber in
            self?.dataManager.getEmployeeData(fileName: "EmployeeList").subscribe(onNext: { employees in
                var allEmployees = employees
                let selectedIndex = allEmployees.firstIndex(where: {$0.id == markedEmployee.id})
                allEmployees.remove(at: selectedIndex ?? 1)
                var newEmployeeList = EmployeeList()
                var employee = markedEmployee
                employee.id = markedEmployee.id
                employee.companyId = markedEmployee.companyId
                employee.name = markedEmployee.name
                employee.department = markedEmployee.department
                employee.status = false
                allEmployees.insert(employee, at: selectedIndex ?? 1)
                newEmployeeList.employeeList = allEmployees
                self?.dataManager.addEmployeeData(fileName: "EmployeeList", employeeList: newEmployeeList).asObservable().subscribe(onNext: { [weak self] success in
                    self?.employees.accept(allEmployees)
                    subscriber.onNext(success)
                }, onError: subscriber.onError(_:)).disposed(by: self?.disposeBag ?? DisposeBag())
            }).disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        })
    }
}
