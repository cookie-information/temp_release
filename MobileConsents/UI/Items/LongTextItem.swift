//
//  LongTextItem.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 10/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class LongTextItem: Item {
    static func registerCells(in tableView: UITableView) {
        tableView.register(HeaderTableViewCell.self)
        tableView.register(ContentTableViewCell.self)
    }
    
    var numberOfCells: Int {
        isExpanded ? 2 : 1
    }
    
    private let title: String
    private let text: String
    
    private var isExpanded = false
    
    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
    
    func cell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        switch indexPath.row {
        case 0: return headerCell(at: indexPath, in: tableView)
        case 1: return contentCell(at: indexPath, in: tableView)
        default: fatalError("Incorrect cell row")
        }
    }
    
    func didSelectCell(at indexPath: IndexPath, in tableView: UITableView) {
        defer {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
        guard indexPath.row == 0 else { return }
        
        isExpanded.toggle()
        (tableView.cellForRow(at: indexPath) as? HeaderTableViewCell)?.setIsExpanded(isExpanded, animated: true)
        
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
    }
    
    private func headerCell(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell: HeaderTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.setTitle(title)
        cell.setIsExpanded(isExpanded, animated: false)
        
        return cell
    }
    
    private func contentCell(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell: ContentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.setText(text)
        
        return cell
    }
}
