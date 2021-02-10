//
//  Item.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 10/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

protocol Item {
    static func registerCells(in tableView: UITableView)
    
    var numberOfCells: Int { get }
    
    func cell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell
    func height(forCellAt indexPath: IndexPath) -> CGFloat
    func didSelectCell(at indexPath: IndexPath, in tableView: UITableView)
}

class BaseItem {
    let numberOfCells = 1
    
    func height(forCellAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func didSelectCell(at indexPath: IndexPath, in tableView: UITableView) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

struct ItemCollection {
    private let items: [Item]
    
    var numberOfSections: Int {
        items.count
    }
    
    init(items: [Item]) {
        self.items = items
    }
    
    subscript(index: Int) -> Item {
        items[index]
    }
    
    subscript(indexPath: IndexPath) -> Item {
        items[indexPath.section]
    }
}
