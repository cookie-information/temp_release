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
        let acceptButtonTitle: String
    }
    
    let translations: Translations
    let sections: [Section]
}

protocol PrivacyCenterViewModelProtocol: AnyObject {
    var onDataLoaded: ((PrivacyCenterData) -> Void)? { get set }
    var onLoadingChange: ((Bool) -> Void)? { get set }
    var onAcceptButtonIsEnabledChange: ((Bool) -> Void)? { get set }
    
    func viewDidLoad()
    func acceptButtonTapped()
    func backButtonTapped()
}

final class PrivacyCenterViewModel {
    var onDataLoaded: ((PrivacyCenterData) -> Void)?
    var onLoadingChange: ((Bool) -> Void)?
    var onAcceptButtonIsEnabledChange: ((Bool) -> Void)?
    
    var router: RouterProtocol?
    
    private let consentSolutionManager: ConsentSolutionManagerProtocol
    private let notificationCenter: NotificationCenter
    
    private var observationToken: Any?
    
    init(
        consentSolutionManager: ConsentSolutionManagerProtocol,
        notificationCenter: NotificationCenter = .default
    ) {
        self.consentSolutionManager = consentSolutionManager
        self.notificationCenter = notificationCenter
    }
    
    deinit {
        if let observationToken = observationToken {
            notificationCenter.removeObserver(observationToken)
        }
    }
}

extension PrivacyCenterViewModel: PrivacyCenterViewModelProtocol {
    func viewDidLoad() {
        observationToken = notificationCenter.addObserver(
            forName: ConsentSolutionManager.consentItemSelectionDidChange,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            self?.onAcceptButtonIsEnabledChange?(self?.consentSolutionManager.areAllRequiredConsentItemsSelected ?? false)
        }
        
        onLoadingChange?(true)
        
        consentSolutionManager.loadConsentSolutionIfNeeded { [weak self] result in
            guard let self = self else { return }
            
            self.onLoadingChange?(false)
            
            guard case .success(let solution) = result else { return }
            
            let sections = SectionGenerator(
                consentItemProvider: self.consentSolutionManager
            ).generateSections(from: solution)
            
            let data = PrivacyCenterData(
                translations: .init(
                    title: solution.templateTexts.privacyCenterTitle.localeTranslation()?.text ?? "",
                    acceptButtonTitle: solution.templateTexts.savePreferencesButton.localeTranslation()?.text ?? ""
                ),
                sections: sections
            )
            
            self.onDataLoaded?(data)
            self.onAcceptButtonIsEnabledChange?(self.consentSolutionManager.areAllRequiredConsentItemsSelected)
        }
    }
    
    func acceptButtonTapped() {
        print("Accept button tapped")
    }
    
    func backButtonTapped() {
        router?.closePrivacyCenter()
    }
}

private final class SectionGenerator {
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
