//
//  PreferencesSection.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 10/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class PreferencesSection: Section {
    private enum Indices {
        static let header = 0
        static let poweredBy = 1
        static let title = 2
        
        static let count = 3
    }
    
    static func registerCells(in tableView: UITableView) {
        [
            HeaderTableViewCell.self,
            SubheaderTableViewCell.self,
            TitleTableViewCell.self,
            SwitchTableViewCell.self,
        ].forEach(tableView.register)
    }
    
    var numberOfCells: Int {
        isExpanded ? (Indices.count + isOn.count) : 1
    }
    
    private var isOn: [Bool]
    private var isExpanded = true
    
    init(isOn: [Bool]) {
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
        switch indexPath.row {
        case Indices.header:
            let cell: HeaderTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setTitle("Preferences")
            cell.setIsExpanded(isExpanded, animated: false)
            
            return cell
        case Indices.poweredBy:
            let cell: SubheaderTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setTitle("Powered by Cookie Information")
            
            return cell
        case Indices.title:
            let cell: TitleTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setTitle("CONSENT PREFERENCES")
            
            return cell
        default:
            let adjustedRow = indexPath.row - Indices.count
            
            let cell: SwitchTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            
            cell.setTitle("Preference \(adjustedRow)")
            cell.setValue(isOn[adjustedRow])
            cell.valueChanged = { [weak self] newValue in
                self?.isOn[adjustedRow] = newValue
            }
            
            return cell
        }
    }
}
