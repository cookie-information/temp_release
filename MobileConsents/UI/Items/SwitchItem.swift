//
//  SwitchItem.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 10/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class SwitchItem: Item {
    private static let cellIdentifier = "SwitchItem"
    
    static func registerCells(in tableView: UITableView) {
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
    }
    
    private let title: String
    private var isOn: Bool
    
    init(title: String, isOn: Bool) {
        self.title = title
        self.isOn = isOn
    }
    
    func cell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath) as! SwitchTableViewCell
        
        cell.setTitle(title)
        cell.setValue(isOn)
        cell.valueChanged = { [weak self] newValue in
            self?.isOn = newValue
        }
        
        return cell
    }
}
