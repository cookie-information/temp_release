//
//  PopUpButtonsSection.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 19/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class PopUpButtonsSection: Section {
    static func registerCells(in tableView: UITableView) {
        tableView.register(ButtonTableViewCell.self)
    }
    
    var numberOfCells: Int { 4 }
    
    func cell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell: ButtonTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.setTitle("Read more")
            cell.setButtonColor(.popUpButton1)
        case 1:
            cell.setTitle("Reject all")
            cell.setButtonColor(.popUpButton1)
        case 2:
            cell.setTitle("Accept all")
            cell.setButtonColor(.popUpButton2)
        case 3:
            cell.setTitle("Accept selected")
            cell.setButtonColor(.popUpButton2)
        default:
            fatalError()
        }
        
        return cell
    }
}
