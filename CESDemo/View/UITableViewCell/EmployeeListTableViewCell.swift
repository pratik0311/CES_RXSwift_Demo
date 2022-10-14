//
//  EmployeeListTableViewCell.swift
//  CESDemo
//
//  Created by Pratik Sakhare on 13/10/22.
//

import UIKit

class EmployeeListTableViewCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var markButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCellData(employee: Employee, index: Int) {
        nameLabel.text = employee.name
        departmentLabel.text = employee.department
        statusLabel.text = employee.status ?? true ? "Active" : "Resigned"
        markButton.isHidden = !(employee.status ?? true)
        markButton.tag = index
    }
}
