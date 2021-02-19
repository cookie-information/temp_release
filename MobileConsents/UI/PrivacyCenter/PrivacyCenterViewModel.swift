//
//  PrivacyCenterViewModel.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 15/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import Foundation

struct PrivacyCenterData {
    struct Translations {
        let title: String
    }
    
    let translations: Translations
    let sections: [Section]
}

protocol PrivacyCenterViewModelProtocol: AnyObject {
    var onDataLoaded: ((PrivacyCenterData) -> Void)? { get set }
    
    func viewDidLoad()
    func acceptButtonTapped()
}

final class PrivacyCenterViewModel {
    var onDataLoaded: ((PrivacyCenterData) -> Void)?
}

extension PrivacyCenterViewModel: PrivacyCenterViewModelProtocol {
    func viewDidLoad() {
        let sections = SectionGenerator().generateSections(from: mockConsentSolution)
        
        let data = PrivacyCenterData(
            translations: .init(
                title: mockConsentSolution.templateTexts.privacyCenterTitle.localeTranslation()?.text ?? ""
            ),
            sections: sections
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.onDataLoaded?(data)
        }
    }
    
    func acceptButtonTapped() {
        print("Accept button tapped")
    }
}

final class SectionGenerator {
    func generateSections(from consentSolution: ConsentSolution) -> [Section] {
        let infoConsentItems = consentSolution.consentItems.filter { $0.type == .info }
        let settingConsentItems = consentSolution.consentItems.filter { $0.type == .setting }
        
        return infoSections(from: infoConsentItems) + [preferencesSection(from: settingConsentItems, templateTexts: consentSolution.templateTexts)]
    }
    
    private func infoSections(from consentItems: [ConsentItem]) -> [Section] {
        consentItems.map { item in
            let translation = item.translations.localeTranslation()
            return ConsentItemSection(
                title: translation?.shortText ?? "",
                text: translation?.longText ?? ""
            )
        }
    }
    
    private func preferencesSection(from consentItems: [ConsentItem], templateTexts: TemplateTexts) -> PreferencesSection {
        let viewModels = consentItems.map { item -> PreferenceViewModel in
            let translation = item.translations.localeTranslation()
            
            return PreferenceViewModel(title: translation?.shortText ?? "", isOn: false)
        }
        
        let translations = PreferencesSection.Translations(
            header: templateTexts.privacyPreferencesTabLabel.localeTranslation()?.text ?? "",
            poweredBy: templateTexts.poweredByCoiLabel.localeTranslation()?.text ?? "",
            title: templateTexts.consentPreferencesLabel.localeTranslation()?.text ?? ""
        )
        
        return PreferencesSection(viewModels: viewModels, translations: translations)
    }
}

private let locale = Locale(identifier: "en_US")

let mockConsentSolution = ConsentSolution(
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
                TemplateTranslation(language: "EN", text: "Save preferences button title")
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
