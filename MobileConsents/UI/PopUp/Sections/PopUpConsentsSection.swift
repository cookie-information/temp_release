//
//  PopUpConsentsSection.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 19/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

protocol PopUpConsentViewModelProtocol: AnyObject {
    var text: String { get }
    var isRequired: Bool { get }
    var isSelected: Bool { get }
    
    func onSelectionChange(_ isSelected: Bool)
}

final class PopUpConsentViewModel: PopUpConsentViewModelProtocol {
    let text: String
    let isRequired: Bool
    private(set) var isSelected = false
    
    init(text: String, isRequired: Bool) {
        self.text = text
        self.isRequired = isRequired
    }
    
    func onSelectionChange(_ isSelected: Bool) {
        self.isSelected = isSelected
        
        print("\(text) selection changed")
    }
}

final class PopUpConsentsSection: Section {
    static func registerCells(in tableView: UITableView) {
        tableView.register(CheckboxTableViewCell.self)
    }
    
    private let viewModels: [PopUpConsentViewModelProtocol]
    
    init(viewModels: [PopUpConsentViewModelProtocol]) {
        self.viewModels = viewModels
    }
    
    var numberOfCells: Int { viewModels.count }
    
    func cell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell: CheckboxTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let viewModel = viewModels[indexPath.row]
        
        cell.setText(viewModel.text, isRequired: viewModel.isRequired)
        cell.setIsSelected(viewModel.isSelected)
        cell.valueChanged = { [weak viewModel] isSelected in
            viewModel?.onSelectionChange(isSelected)
        }
        
        return cell
    }
}
