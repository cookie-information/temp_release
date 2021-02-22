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
    func backButtonTapped()
}

final class PrivacyCenterViewModel {
    var onDataLoaded: ((PrivacyCenterData) -> Void)?
    
    var router: RouterProtocol?
    
    private let consentSolutionManager: ConsentSolutionManagerProtocol
    
    init(consentSolutionManager: ConsentSolutionManagerProtocol) {
        self.consentSolutionManager = consentSolutionManager
    }
}

extension PrivacyCenterViewModel: PrivacyCenterViewModelProtocol {
    func viewDidLoad() {
        consentSolutionManager.loadConsentSolutionIfNeeded { [weak self] result in
            guard let self = self else { return }
            guard case .success(let solution) = result else { return }
            
            let sections = SectionGenerator(
                consentItemProvider: self.consentSolutionManager
            ).generateSections(from: solution)
            
            let data = PrivacyCenterData(
                translations: .init(
                    title: solution.templateTexts.privacyCenterTitle.localeTranslation()?.text ?? ""
                ),
                sections: sections
            )
            
            self.onDataLoaded?(data)
        }
    }
    
    func acceptButtonTapped() {
        print("Accept button tapped")
    }
    
    func backButtonTapped() {
        router?.closePrivacyCenter()
    }
}

final class SectionGenerator {
    private let consentItemProvider: ConsentItemProvider
    
    init(consentItemProvider: ConsentItemProvider) {
        self.consentItemProvider = consentItemProvider
    }
    
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
            
            return PreferenceViewModel(
                id: item.id,
                text: translation?.shortText ?? "",
                consentItemProvider: consentItemProvider
            )
        }
        
        let translations = PreferencesSection.Translations(
            header: templateTexts.privacyPreferencesTabLabel.localeTranslation()?.text ?? "",
            poweredBy: templateTexts.poweredByCoiLabel.localeTranslation()?.text ?? "",
            title: templateTexts.consentPreferencesLabel.localeTranslation()?.text ?? ""
        )
        
        return PreferencesSection(viewModels: viewModels, translations: translations)
    }
}
