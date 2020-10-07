//
//  MobileConsentsSolutionViewModel.swift
//  Example
//
//  Created by Jan Lipmann on 01/10/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation
import MobileConsentsSDK

protocol MobileConsentSolutionViewModelProtocol {
    var consentSolution: ConsentSolution? { get }
    var sectionsCount: Int { get }
    var sendAvailable: Bool { get }
    func sectionType(for section: Int) -> MobileConsentsSolutionSectionType?
    func cellType(for indexPath: IndexPath) -> MobileConsentsSolutionCellType?
    func rowsCount(for section: Int) -> Int
    func item(for indexPath: IndexPath) -> ConsentItem?
    func translation(for indexPath: IndexPath) -> ConsentTranslation?
    func handleItemCheck(_ item: ConsentItem)
    func isItemSelected(_ item: ConsentItem) -> Bool
    func fetchData(for identifier: String, _ completion:@escaping (Error?) -> Void)
}

final class MobileConsentSolutionViewModel: MobileConsentSolutionViewModelProtocol {
    private let mobileConsentsSDK = MobileConsentsSDK(withBaseURL: URL(string: "https//google.com")!)
    private var selectedItems: [ConsentItem] = []
    
    private var items: [ConsentItem] {
        return consentSolution?.consentItems ?? []
    }
    
    private var sectionTypes: [MobileConsentsSolutionSectionType] {
        guard consentSolution != nil else { return [] }
    
        var sectionTypes: [MobileConsentsSolutionSectionType] = [.info]
        if !items.isEmpty {
            sectionTypes.append(.items)
        }
        return sectionTypes
    }

    var consentSolution: ConsentSolution?

    var sectionsCount: Int {
        sectionTypes.count
    }
    
    var sendAvailable: Bool {
        !selectedItems.isEmpty
    }
    
    private func cellTypes(forSection section: Int) -> [MobileConsentsSolutionCellType] {
        guard let type = sectionType(for: section) else { return [] }
        
        switch type {
        case .info: return [.solutionDetails]
        case .items: return Array(repeating: .consentItem, count: items.count)
        }
    }
    
    func sectionType(for section: Int) -> MobileConsentsSolutionSectionType? {
        return sectionTypes[safe: section]
    }
    
    func cellType(for indexPath: IndexPath) -> MobileConsentsSolutionCellType? {
        return cellTypes(forSection: indexPath.section)[safe: indexPath.row]
    }
    
    func rowsCount(for section: Int) -> Int {
        return cellTypes(forSection: section).count
    }
    
    func item(for indexPath: IndexPath) -> ConsentItem? {
        guard sectionType(for: indexPath.section) == .items  else { return nil }
        
        return items[safe: indexPath.row]
    }
    
    func translation(for indexPath: IndexPath) -> ConsentTranslation? {
        guard sectionType(for: indexPath.section) == .items  else { return nil }
        
        return items[safe: indexPath.row]?.translations[safe: indexPath.row - 1]
    }
    
    func handleItemCheck(_ item: ConsentItem) {
        if let index = selectedItems.firstIndex(where: { $0.id == item.id }) {
            selectedItems.remove(at: index)
        } else {
            selectedItems.append(item)
        }
    }
    
    func isItemSelected(_ item: ConsentItem) -> Bool {
        return selectedItems.contains(where: { $0.id == item.id })
    }
    
    func fetchData(for identifier: String, _ completion:@escaping (Error?) -> Void) {
        mobileConsentsSDK.fetchConsentSolution(forUniversalConsentSolutionId: identifier, completion: { [weak self] solution, error in
            if let error = error {
                completion(error)
            } else {
                self?.consentSolution = solution
                completion(nil)
            }
        })
    }
}
