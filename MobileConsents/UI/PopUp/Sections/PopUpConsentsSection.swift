//
//  PopUpConsentsSection.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 19/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class PopUpConsentsSection: Section {
    static func registerCells(in tableView: UITableView) {
        tableView.register(CheckboxTableViewCell.self)
    }
    
    var numberOfCells: Int { 4 }
    
    func cell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell: CheckboxTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        return cell
    }
}
