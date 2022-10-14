//
//  RegistrationViewModel.swift
//  CESDemo
//
//  Created by Pratik Sakhare on 12/10/22.
//

import Foundation
import RxSwift
import RxCocoa

class RegistrationViewModel {
    var dataManager = DataManager()
    let nameSubject = BehaviorRelay<String?>(value: "")
    let locationSubject = BehaviorRelay<String?>(value: "")
    let passwordSubject = BehaviorRelay<String?>(value: "")
    let disposeBag = DisposeBag()
    
    func saveCompanyDataToFile() -> Observable<Bool> {
        Observable.create({ [weak self] subscriber in
            var companyList = self?.dataManager.getCompanyData(fileName: "CompanyList")
            var newCompanyList = CompanyList()
            var company = Company()
            company.id = self?.nameSubject.value
            company.name = self?.nameSubject.value
            company.location = self?.locationSubject.value
            company.password = self?.passwordSubject.value
            companyList?.append(company)
            newCompanyList.companyList = companyList
            self?.dataManager.addCompanyData(fileName: "CompanyList", companyList: newCompanyList).asObservable().subscribe(onNext: { success in
                subscriber.onNext(success)
            }, onError: subscriber.onError(_:)).disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        })
    }
    
    func validateRegistrationForm() -> (success: Bool, errorType: String) {
        let companyList = dataManager.getCompanyData(fileName: "CompanyList")
        guard let name = nameSubject.value, let location = locationSubject.value, let password = passwordSubject.value, !(name.isEmpty), !(location.isEmpty), !(password.isEmpty) else {
            return (success: false, errorType: "field_validation")
        }
        if (companyList?.filter({$0.id == name}).first != nil) {
            return (success: false, errorType: "company_exist")
        }
        return (success: true, errorType: "")
    }
}
