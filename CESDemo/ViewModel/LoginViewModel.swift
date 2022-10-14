//
//  LoginViewModel.swift
//  CESDemo
//
//  Created by Pratik Sakhare on 13/10/22.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    var dataManager = DataManager()
    let nameSubject = BehaviorRelay<String?>(value: "")
    let passwordSubject = BehaviorRelay<String?>(value: "")
    let disposeBag = DisposeBag()

    func validateLoginForm() -> (success: Bool, errorType: String) {
        let companyList = dataManager.getCompanyData(fileName: "CompanyList")
        guard let name = nameSubject.value, let password = passwordSubject.value, !(name.isEmpty), !(password.isEmpty) else {
            return (success: false, errorType: "field_validation")
        }
        let loginCompany = companyList?.filter({$0.id == name}).first
        if loginCompany == nil {
            return (success: false, errorType: "company_not_exist")
        }
        if loginCompany?.password != password {
            return (success: false, errorType: "wrong_password")
        }
        return (success: true, errorType: "")
    }
}
