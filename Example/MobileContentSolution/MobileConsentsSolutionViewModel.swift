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
    var savedConsents: [SavedConsent] { get }
    func showPrivacyPopUp(for identifier: String)
}

final class MobileConsentSolutionViewModel: MobileConsentSolutionViewModelProtocol {
    private let mobileConsentsSDK = MobileConsents(clientID: "68290ff1-da48-4e61-9eb9-590b86d9a8b9",
                                                   clientSecret: "bfa6f31561827fbc59c5d9dc0b04bdfd9752305ce814e87533e61ea90f9f8da8743c376074e372d3386c2a608c267fe1583472fe6369e3fa9cf0082f7fe2d56d", accentColor: .systemPink)
    
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
    
    
   
    
    func isItemSelected(_ item: ConsentItem) -> Bool {
        return selectedItems.contains(where: { $0.id == item.id })
    }
    
    func showPrivacyPopUp(for identifier: String) {
        // Display the popup and provide a closure for handling the user constent.
        // This completion closure is the place to display
        mobileConsentsSDK.showPrivacyPopUp(forUniversalConsentSolutionId: identifier) { settings in
            settings.forEach { consent in
                switch consent.purpose {
                case .statistical: break
                case .functional: break
                case .marketing: break
                case .necessary: break
                case .custom(title: let title):
                    if title.lowercased() == "age consent" {
                        // handle user defined consent items such as age consent
                    }
                @unknown default:
                    break
                }
                print("Consent given for: \(consent.purpose)")
            }
        }
    }
    
}
