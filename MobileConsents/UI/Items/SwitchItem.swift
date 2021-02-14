//
//  SwitchItem.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 10/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class SwitchItem: Item {
    static func registerCells(in tableView: UITableView) {
        tableView.register(HeaderTableViewCell.self)
        tableView.register(SwitchTableViewCell.self)
    }
    
    var numberOfCells: Int {
        isExpanded ? 5 : 1
    }
    
    private let title: String
    private var isOn: Bool
    private var isExpanded = true
    
    init(title: String, isOn: Bool) {
        self.title = title
        self.isOn = isOn
    }
    
    func didSelectCell(at indexPath: IndexPath, in tableView: UITableView) {
        defer { tableView.deselectRow(at: indexPath, animated: false) }
        
        guard indexPath.row == 0 else { return }
        
        isExpanded.toggle()
        (tableView.cellForRow(at: indexPath) as? HeaderTableViewCell)?.setIsExpanded(isExpanded, animated: true)
        
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
    }
    
    func cell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        guard indexPath.row > 0 else {
            let cell: HeaderTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setTitle("Preferences")
            cell.setIsExpanded(isExpanded, animated: false)
            
            return cell
        }
        
        let cell: SwitchTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.setTitle(title)
        cell.setValue(isOn)
        cell.valueChanged = { [weak self] newValue in
            self?.isOn = newValue
        }
        
        return cell
    }
}
