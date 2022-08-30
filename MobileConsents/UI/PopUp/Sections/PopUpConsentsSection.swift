//
//  PopUpConsentsSection.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 19/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

final class PopUpConsentViewModel: SwitchCellViewModel {
    var accentColor: UIColor
    
    let text: String
    let isRequired: Bool
    
    var isSelected: Bool { consentItemProvider.isConsentItemSelected(id: id)  || consentItemProvider.isConsentItemRequired(id: id)}
    var onUpdate: ((SwitchCellViewModel) -> Void)?
    
    private let id: String
    private let consentItemProvider: ConsentItemProvider
    private let notificationCenter: NotificationCenter
    
    private var observationToken: Any?
    
    init(
        id: String,
        text: String,
        isRequired: Bool,
        consentItemProvider: ConsentItemProvider,
        notificationCenter: NotificationCenter = NotificationCenter.default,
        accentColor: UIColor
    ) {
        self.id = id
        self.text = text
        self.isRequired = isRequired
        self.consentItemProvider = consentItemProvider
        self.notificationCenter = notificationCenter
        self.accentColor = accentColor
        observationToken = notificationCenter.addObserver(
            forName: ConsentSolutionManager.consentItemSelectionDidChange,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            guard let self = self else { return }
            self.onUpdate?(self)
        }
    }
    
    deinit {
        if let observationToken = observationToken {
            notificationCenter.removeObserver(observationToken)
        }
    }
    
    func selectionDidChange(_ isSelected: Bool) {
        consentItemProvider.markConsentItem(id: id, asSelected: isSelected)
    }
}

final class PopUpConsentsSection: Section {
    static func registerCells(in tableView: UITableView) {
        tableView.register(SwitchTableViewCell.self)
    }
    
    private let viewModels: [SwitchCellViewModel]
    
    init(viewModels: [SwitchCellViewModel]) {
        self.viewModels = viewModels
    }
    
    var numberOfCells: Int { viewModels.count }
    
    func cell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell: SwitchTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let viewModel = viewModels[indexPath.row]
        
        cell.setViewModel(viewModel)
        
        return cell
    }
}
