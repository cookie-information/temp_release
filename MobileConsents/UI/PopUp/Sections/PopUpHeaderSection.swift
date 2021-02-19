//
//  PopUpHeaderSection.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 19/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class PopUpHeaderSection: Section {
    static func registerCells(in tableView: UITableView) {
        tableView.register(PopUpHeaderTableViewCell.self)
    }
    
    func cell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell: PopUpHeaderTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.setTitle("Test title")
        cell.setDescription("Test description")
        
        return cell
    }
}
