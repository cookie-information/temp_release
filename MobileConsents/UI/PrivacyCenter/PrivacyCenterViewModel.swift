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
    var onError: ((ErrorAlertModel) -> Void)? { get set }
    var onLoadingChange: ((Bool) -> Void)? { get set }
    var onAcceptButtonIsEnabledChange: ((Bool) -> Void)? { get set }
    
    func viewDidLoad()
    func acceptButtonTapped()
    func backButtonTapped()
}

final class PrivacyCenterViewModel {
    var onDataLoaded: ((PrivacyCenterData) -> Void)?
    var onError: ((ErrorAlertModel) -> Void)?
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
        
        loadConsentSolution()
    }
    
    func acceptButtonTapped() {
        onLoadingChange?(true)
        consentSolutionManager.acceptSelectedConsentItems { [weak self] error in
            self?.handlePostingConsent(error: error)
        }
    }
    
    func backButtonTapped() {
        router?.closePrivacyCenter()
    }
    
    private func loadConsentSolution() {
        onLoadingChange?(true)
        
        consentSolutionManager.loadConsentSolutionIfNeeded { [weak self] result in
            guard let self = self else { return }
            
            self.onLoadingChange?(false)
            
            guard case .success(let solution) = result else {
                self.handleConsentSolutionLoadingError()
                
                return
            }
            
            let sections = SectionGenerator(
                consentItemProvider: self.consentSolutionManager
            ).generateSections(from: solution)
            
            let data = PrivacyCenterData(
                translations: .init(
                    title: solution.templateTexts.privacyCenterTitle.primaryTranslation()?.text ?? "",
                    acceptButtonTitle: solution.templateTexts.savePreferencesButton.primaryTranslation()?.text ?? ""
                ),
                sections: sections
            )
            
            self.onDataLoaded?(data)
            self.onAcceptButtonIsEnabledChange?(self.consentSolutionManager.areAllRequiredConsentItemsSelected)
        }
    }
    
    private func handleConsentSolutionLoadingError() {
        onError?(.init(
            retryHandler: { [weak self] in
                self?.loadConsentSolution()
            },
            cancelHandler: { [weak self] in
                self?.router?.closeAll()
            }
        ))
    }
    
    private func handlePostingConsent(error: Error?) {
        onLoadingChange?(false)
        
        if error == nil {
            router?.closeAll()
        } else {
            onError?(.init(
                retryHandler: { [weak self] in
                    self?.acceptButtonTapped()
                },
                cancelHandler: nil
            ))
        }
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
            let translation = item.translations.primaryTranslation()
            return ConsentItemSection(
                title: translation?.shortText ?? "",
                text: translation?.longText ?? ""
            )
        }
    }
    
    private func preferencesSection(from consentItems: [ConsentItem], templateTexts: TemplateTexts) -> PreferencesSection {
        let viewModels = consentItems.map { item -> PreferenceViewModel in
            let translation = item.translations.primaryTranslation()
            
            return PreferenceViewModel(
                id: item.id,
                text: translation?.shortText ?? "",
                isRequired: item.required,
                consentItemProvider: consentItemProvider
            )
        }
        
        let translations = PreferencesSection.Translations(
            header: templateTexts.privacyPreferencesTabLabel.primaryTranslation()?.text ?? "",
            poweredBy: templateTexts.poweredByCoiLabel.primaryTranslation()?.text ?? "",
            title: templateTexts.consentPreferencesLabel.primaryTranslation()?.text ?? ""
        )
        
        return PreferencesSection(viewModels: viewModels, translations: translations)
    }
}
