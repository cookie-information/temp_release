//
//  Section.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 10/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

protocol Section {
    static func registerCells(in tableView: UITableView)
    
    var numberOfCells: Int { get }
    
    func cell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell
    func didSelectCell(at indexPath: IndexPath, in tableView: UITableView)
}

extension Section {
    var numberOfCells: Int { 1 }
    
    func didSelectCell(at indexPath: IndexPath, in tableView: UITableView) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
