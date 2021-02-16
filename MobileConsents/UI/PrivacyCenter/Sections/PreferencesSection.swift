//
//  PreferencesSection.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 10/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

protocol PreferenceViewModelProtocol: AnyObject {
    var title: String { get }
    var isOn: Bool { get set }
    
//    var valueChanged: ((Bool) -> Void)? { get set }
}

final class PreferenceViewModel: PreferenceViewModelProtocol {
    let title: String
    
    var isOn: Bool
    
    init(title: String, isOn: Bool) {
        self.title = title
        self.isOn = isOn
    }
}

final class PreferencesSection: Section {
    struct Translations {
        let header: String
        let poweredBy: String
        let title: String
    }
    
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
        isExpanded ? (Indices.count + viewModels.count) : 1
    }
    
    private let viewModels: [PreferenceViewModelProtocol]
    private let translations: Translations
    private var isExpanded = true
    
    init(viewModels: [PreferenceViewModelProtocol], translations: Translations) {
        self.viewModels = viewModels
        self.translations = translations
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
            return headerCell(for: indexPath, in: tableView)
        case Indices.poweredBy:
            return poweredByCell(for: indexPath, in: tableView)
        case Indices.title:
            return titleCell(for: indexPath, in: tableView)
        default:
            return switchCell(for: indexPath, in: tableView)
        }
    }
    
    private func headerCell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell: HeaderTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setTitle(translations.header)
        cell.setIsExpanded(isExpanded, animated: false)
        
        return cell
    }
    
    private func poweredByCell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell: SubheaderTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setTitle(translations.poweredBy)
        
        return cell
    }
    
    private func titleCell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell: TitleTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setTitle(translations.title)
        
        return cell
    }
    
    private func switchCell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let adjustedRow = indexPath.row - Indices.count
        
        let cell: SwitchTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.isSeparatorHidden = indexPath.row != (numberOfCells - 1) // Show separator only in last cell
        
        let viewModel = viewModels[adjustedRow]
        
        cell.setTitle(viewModel.title)
        cell.setValue(viewModel.isOn)
        cell.valueChanged = { [weak viewModel] newValue in
            viewModel?.isOn = newValue
        }
        
        return cell
    }
}
