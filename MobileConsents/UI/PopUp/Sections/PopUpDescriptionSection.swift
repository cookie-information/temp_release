//
//  PopUpDescriptionSection.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 19/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class PopUpDescriptionSection: Section {
    static func registerCells(in tableView: UITableView) {
        tableView.register(PopUpDescriptionTableViewCell.self)
    }
    
    func cell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell: PopUpDescriptionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setText("Test description")
        
        return cell
    }
}
