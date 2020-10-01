//
//  MobileConsentsSolutionViewModel.swift
//  Example
//
//  Created by Jan Lipmann on 01/10/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation
import MobileConsentsSDK

class MobileConsentSolutionViewModel {
    var consentSolution: ConsentSolution?
    private var selectedItems: [ConsentItem] = []
    
    private let mobileConsentsSDK = MobileConsentsSDK(withBaseURL: URL(string: "https//google.com")!)
    
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
    
    var sectionsCount: Int {
        sectionTypes.count
    }
    
    func sectionType(forSection section: Int) -> MobileConsentsSolutionSectionType {
        return sectionTypes[section]
    }
    
    private func cellTypes(forSection section: Int) -> [MobileConsentsSolutionCellType] {
        switch sectionType(forSection: section) {
        case .info:
            return [.solutionDetails]
        case .items:
            return Array(repeating: .consentItem, count: items.count)
        }
    }
    
    func cellType(forIndexPath indexPath: IndexPath) -> MobileConsentsSolutionCellType {
        return cellTypes(forSection: indexPath.section)[indexPath.row]
    }
    
    func rowsCount(forSection section: Int) -> Int {
        return cellTypes(forSection: section).count
    }
    
    func item(forIndexPath indexPath: IndexPath) -> ConsentItem? {
        guard sectionType(forSection: indexPath.section) == .items  else { return nil }
        return items[safe: indexPath.row]
    }
    
    func translation(forIndexPath indexPath: IndexPath) -> ConsentTranslation? {
        guard sectionType(forSection: indexPath.section) == .items  else { return nil }
        return items[safe: indexPath.row]?.translations[safe: indexPath.row - 1]
    }
    
    func fetchData(forIdentifier identifier: String, _ completion:@escaping (Error?) -> Void) {
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
