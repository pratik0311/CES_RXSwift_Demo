//
//  EmployeeList.swift
//  CESDemo
//
//  Created by Pratik Sakhare on 13/10/22.
//

import Foundation

struct EmployeeList: Codable {
    var employeeList: [Employee]?
}

struct Employee: Codable {
    var companyId: String?
    var id: String?
    var name: String?
    var department: String?
    var status: Bool?
}
