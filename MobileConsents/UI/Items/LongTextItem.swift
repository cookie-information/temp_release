//
//  LongTextItem.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 10/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class LongTextItem: Item {
    private enum CellIdentifiers {
        static let header = "LongTextItemHeader"
        static let content = "LongTextItemContent"
    }
    
    static func registerCells(in tableView: UITableView) {
        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: CellIdentifiers.header)
        tableView.register(ContentTableViewCell.self, forCellReuseIdentifier: CellIdentifiers.content)
    }
    
    let numberOfCells = 2
    
    private let title: String
    private let text: String
    
    private var isExpanded = true
    
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
        switch indexPath.row {
        case 0:
            isExpanded.toggle()
            
//            tableView.reloadRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .automatic)
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func height(forCellAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return UITableView.automaticDimension
        case 1: return isExpanded ? UITableView.automaticDimension : .zero
        default: fatalError("Incorrect row")
        }
    }
    
    private func headerCell(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.header, for: indexPath) as! HeaderTableViewCell
        
        cell.setTitle(title)
        
        return cell
    }
    
    private func contentCell(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.content, for: indexPath) as! ContentTableViewCell
        
        cell.setText(text)
        
        return cell
    }
}
