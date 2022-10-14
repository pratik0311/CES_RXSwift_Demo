//
//  CompanyList.swift
//  CESDemo
//
//  Created by Pratik Sakhare on 12/10/22.
//

import Foundation

struct CompanyList: Codable {
    var companyList: [Company]?
}

struct Company: Codable {
    var id: String?
    var name: String?
    var location: String?
    var password: String?
}
