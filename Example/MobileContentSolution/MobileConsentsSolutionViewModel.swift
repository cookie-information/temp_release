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
    var savedConsents: [SavedConsent] { get }
    func sectionType(for section: Int) -> MobileConsentsSolutionSectionType?
    func cellType(for indexPath: IndexPath) -> MobileConsentsSolutionCellType?
    func rowsCount(for section: Int) -> Int
    func item(for indexPath: IndexPath) -> ConsentItem?
    func translation(for indexPath: IndexPath) -> ConsentTranslation?
    func handleItemCheck(_ item: ConsentItem)
    func isItemSelected(_ item: ConsentItem) -> Bool
    func fetchData(for identifier: String, language: String, _ completion:@escaping (Error?) -> Void)
    func sendData( _ completion:@escaping (Error?) -> Void)
    func showPrivacyPopUp(for identifier: String)
    func showPrivacyCenter(for identifier: String)
}

final class MobileConsentSolutionViewModel: MobileConsentSolutionViewModelProtocol {
    private let mobileConsentsSDK = MobileConsents(withBaseURL: URL(string: "https://consents-gathering-app-staging.app.cookieinformation.com")!)
    private var selectedItems: [ConsentItem] = []
    private var language: String?
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
        consentSolution != nil
    }
    
    var savedConsents: [SavedConsent] {
        return mobileConsentsSDK.getSavedConsents()
    }
    
    private var consent: Consent? {
        guard let consentSolution = consentSolution, let language = language else { return nil }
        
        let customData = ["email": "test@test.com", "device_id": "824c259c-7bf5-4d2a-81bf-22c09af31261"]
        var consent = Consent(consentSolutionId: consentSolution.id, consentSolutionVersionId: consentSolution.versionId, customData: customData)
        
        items.forEach { item in
            let selected = selectedItems.contains(where: { $0.id == item.id })
            let purpose = ProcessingPurpose(consentItemId: item.id, consentGiven: selected, language: language)
            consent.addProcessingPurpose(purpose)
        }
        
        return consent
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
        
        return items[safe: indexPath.row]?.translations.translations[safe: indexPath.row - 1]
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
    
    func fetchData(for identifier: String, language: String, _ completion: @escaping (Error?) -> Void) {
        self.language = language
        mobileConsentsSDK.fetchConsentSolution(forUniversalConsentSolutionId: identifier, completion: { [weak self] result in
            switch result {
            case .success(let consentSolution):
                self?.consentSolution = consentSolution
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        })
    }
    
    func sendData( _ completion: @escaping (Error?) -> Void) {
        guard let consent = consent else {
            completion(MobileConsentError.noConsentToSend)
            return
        }

        mobileConsentsSDK.postConsent(consent, completion: completion)
    }
    
    func showPrivacyPopUp(for identifier: String) {
        mobileConsentsSDK.showPopUp(forUniversalConsentSolutionId: identifier)
    }
    
    func showPrivacyCenter(for identifier: String) {
        print("Show privacy center")
    }
}
