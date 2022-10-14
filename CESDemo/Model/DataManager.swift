//
//  DataProvider.swift
//  CESDemo
//
//  Created by Pratik Sakhare on 12/10/22.
//

import Foundation
import RxSwift

class DataManager {
    
    func getCompanyData(fileName: String) -> [Company]? {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
                let subUrl = documentDirectory.appendingPathComponent("\(fileName).json")
            let data = try Data(contentsOf: subUrl)
            let decoder = JSONDecoder()
            let companyList = try decoder.decode(CompanyList.self, from: data)
            return companyList.companyList
        } catch {
            print("error:\(error)")
            return []
        }
    }
    
    func addCompanyData(fileName: String, companyList: CompanyList) -> Observable<Bool> {
        Observable.create({ subscriber in
            do {
                let furl = try FileManager.default
                    .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent(fileName)
                    .appendingPathExtension("json")
                let data = try JSONEncoder().encode(companyList)
                try data.write(to: furl)
                subscriber.onNext(true)
            } catch {
                subscriber.onNext(false)
            }
            return Disposables.create()
        })
    }
    
    func getEmployeeData(fileName: String) -> Observable<[Employee]> {
        Observable.create({ subscriber in
            do {
                let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
                    let subUrl = documentDirectory.appendingPathComponent("\(fileName).json")
                let data = try Data(contentsOf: subUrl)
                let decoder = JSONDecoder()
                let employeeList = try decoder.decode(EmployeeList.self, from: data)
                subscriber.onNext(employeeList.employeeList ?? [])
            } catch {
                print("error:\(error)")
                subscriber.onNext([])
            }
            return Disposables.create()
        })
    }
    
    func addEmployeeData(fileName: String, employeeList: EmployeeList) -> Observable<Bool> {
        Observable.create({ subscriber in
            do {
                let furl = try FileManager.default
                    .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent(fileName)
                    .appendingPathExtension("json")
                let data = try JSONEncoder().encode(employeeList)
                try data.write(to: furl)
                subscriber.onNext(true)
            } catch {
                subscriber.onNext(false)
            }
            return Disposables.create()
        })
    }
}
