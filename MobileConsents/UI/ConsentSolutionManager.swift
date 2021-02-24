//
//  ConsentSolutionManager.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 22/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import Foundation

protocol AsyncDispatcher {
    func async(execute work: @escaping () -> Void)
}

extension DispatchQueue: AsyncDispatcher {
    func async(execute work: @escaping () -> Void) {
        async(group: nil, qos: .unspecified, flags: [], execute: work)
    }
}

protocol ConsentItemProvider {
    func isConsentItemSelected(id: String) -> Bool
    func markConsentItem(id: String, asSelected selected: Bool)
}

protocol ConsentSolutionManagerProtocol: ConsentItemProvider {
    var areAllRequiredConsentItemsSelected: Bool { get }
    var hasRequiredConsentItems: Bool { get }
    
    func loadConsentSolutionIfNeeded(completion: @escaping (Result<ConsentSolution, Error>) -> Void)
    
    func rejectAllConsentItems()
    func acceptAllConsentItems()
    func acceptSelectedConsentItems()
}

final class ConsentSolutionManager: ConsentSolutionManagerProtocol {
    static let consentItemSelectionDidChange = Notification.Name(rawValue: "com.cookieinformation.consentItemSelectionDidChange")
    
    var areAllRequiredConsentItemsSelected: Bool {
        consentSolution?
            .consentItems
            .filter { $0.required && $0.type == .setting }
            .map(\.id)
            .allSatisfy(selectedConsentItemIds.contains)
            ??
            false
    }
    
    var hasRequiredConsentItems: Bool {
        !(consentSolution?
            .consentItems
            .filter { $0.required && $0.type == .setting }
            .isEmpty
            ??
            true)
    }
    
    private let consentSolutionId: String
    private let mobileConsents: MobileConsentsProtocol
    private let notificationCenter: NotificationCenter
    private let asyncDispatcher: AsyncDispatcher
    
    private var consentSolution: ConsentSolution?
    private var selectedConsentItemIds = Set<String>()
    
    init(
        consentSolutionId: String,
        mobileConsents: MobileConsentsProtocol,
        notificationCenter: NotificationCenter = NotificationCenter.default,
        asyncDispatcher: AsyncDispatcher = DispatchQueue.main
    ) {
        self.consentSolutionId = consentSolutionId
        self.mobileConsents = mobileConsents
        self.notificationCenter = notificationCenter
        self.asyncDispatcher = asyncDispatcher
    }
    
    func loadConsentSolutionIfNeeded(completion: @escaping (Result<ConsentSolution, Error>) -> Void) {
        if let consentSolution = consentSolution {
            completion(.success(consentSolution))
            
            return
        }
        
        mobileConsents.fetchConsentSolution(forUniversalConsentSolutionId: consentSolutionId) { [weak self, asyncDispatcher] result in
            asyncDispatcher.async {
                if case .success(let solution) = result {
                    self?.consentSolution = solution
                }
                
                completion(result)
            }
        }
    }
    
    func isConsentItemSelected(id: String) -> Bool {
        selectedConsentItemIds.contains(id)
    }
    
    func markConsentItem(id: String, asSelected selected: Bool) {
        if selected {
            selectedConsentItemIds.insert(id)
        } else {
            selectedConsentItemIds.remove(id)
        }
        
        postConsentItemSelectionDidChangeNotification()
    }
    
    func rejectAllConsentItems() {
        selectedConsentItemIds.removeAll()
        
        postConsentItemSelectionDidChangeNotification()
    }
    
    func acceptAllConsentItems() {
        consentSolution?.consentItems.map(\.id).forEach { selectedConsentItemIds.insert($0) }
        
        postConsentItemSelectionDidChangeNotification()
    }
    
    func acceptSelectedConsentItems() {}
    
    private func postConsentItemSelectionDidChangeNotification() {
        notificationCenter.post(Notification(name: Self.consentItemSelectionDidChange))
    }
}

final class MockMobileConsents: MobileConsentsProtocol {
    func fetchConsentSolution(forUniversalConsentSolutionId universalConsentSolutionId: String, completion: @escaping (Result<ConsentSolution, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(mockConsentSolution))
        }
    }
    
    func postConsent(_ consent: Consent, completion: @escaping (Error?) -> Void) {
        completion(nil)
    }
}

private let locale = Locale(identifier: "en_US")

private let mockConsentSolution = ConsentSolution(
    id: "9187d0f0-9e25-469b-9125-6a63b1b22b12",
    versionId: "00000000-0000-4000-8000-000000000000",
    title: Translated(
        translations: [
            TemplateTranslation(language: "EN", text: "Privacy title")
        ],
        locale: locale
    ),
    description: Translated(
        translations: [
            TemplateTranslation(
                language: "EN",
                text: """
                Privacy description. Lorem ipsum dolor<br>Some link <a href="https://apple.com">here</a>
                """
            )
        ],
        locale: locale
    ),
    templateTexts: TemplateTexts(
        privacyCenterButton: Translated(
            translations: [
                TemplateTranslation(language: "EN", text: "Privacy center button title")
            ],
            locale: locale
        ),
        rejectAllButton: Translated(
            translations: [
                TemplateTranslation(language: "EN", text: "Reject all button title")
            ],
            locale: locale
        ),
        acceptAllButton: Translated(
            translations: [
                TemplateTranslation(language: "EN", text: "Accept all button title")
            ],
            locale: locale
        ),
        acceptSelectedButton: Translated(
            translations: [
                TemplateTranslation(language: "EN", text: "Accept selected button title")
            ],
            locale: locale
        ),
        savePreferencesButton: Translated(
            translations: [
                TemplateTranslation(language: "EN", text: "Accept")
            ],
            locale: locale
        ),
        privacyCenterTitle: Translated(
            translations: [
                TemplateTranslation(language: "EN", text: "Privacy center title")
            ],
            locale: locale
        ),
        privacyPreferencesTabLabel: Translated(
            translations: [
                TemplateTranslation(language: "EN", text: "Privacy preferences tab")
            ],
            locale: locale
        ),
        poweredByCoiLabel: Translated(
            translations: [
                TemplateTranslation(language: "EN", text: "Powered by Cookie Information")
            ],
            locale: locale
        ),
        consentPreferencesLabel: Translated(
            translations: [
                TemplateTranslation(language: "EN", text: "Consent preferences label")
            ],
            locale: locale
        )
    ),
    consentItems: [
        ConsentItem(
            id: "a10853b5-85b8-4541-a9ab-fd203176bdce",
            required: true,
            type: .setting,
            translations: Translated(
                translations: [
                    ConsentTranslation(
                        language: "EN",
                        shortText: "First consent item short text",
                        longText: "First consent item long text"
                    )
                ],
                locale: locale
            )
        ),
        ConsentItem(
            id: "ef7d8f35-fc1a-4369-ada2-c00cc0eecc4b",
            required: false,
            type: .setting,
            translations: Translated(
                translations: [
                    ConsentTranslation(
                        language: "EN",
                        shortText: "Second consent item short text",
                        longText: """
                        Example html capabilities<br>
                        Lists:<br>
                        <ul>
                        <li><b>Bold text</b></li>
                        <li><em>Emphasized text</em></li>
                        <li><b><i>Bold and emphasized text</i></b></li>
                        <li><a href=\"https://apple.com\">Link to website</a></li>
                        <li><span style=\"color:red\">Text with custom color</span></li>
                        </ul>
                        """
                    )
                ],
                locale: locale
            )
        ),
        ConsentItem(
            id: "7d477dbf-5f88-420f-8dfc-2506907ebe07",
            required: true,
            type: .info,
            translations: Translated(
                translations: [
                    ConsentTranslation(
                        language: "EN",
                        shortText: "Third consent item short text",
                        longText: """
                        Example html capabilities<br>
                        Lists:<br>
                        <ul>
                        <li><b>Bold text</b></li>
                        <li><em>Emphasized text</em></li>
                        <li><b><i>Bold and emphasized text</i></b></li>
                        <li><a href=\"https://apple.com\">Link to website</a></li>
                        <li><span style=\"color:red\">Text with custom color</span></li>
                        </ul>
                        """
                    )
                ],
                locale: locale
            )
        ),
        ConsentItem(
            id: "1d5920c7-c5d1-4c08-93cc-4238457d7a1f",
            required: true,
            type: .info,
            translations: Translated(
                translations: [
                    ConsentTranslation(
                        language: "EN",
                        shortText: "Fourth consent item short text",
                        longText: "Fourth consent item long text"
                    )
                ],
                locale: locale
            )
        )
    ]
)
