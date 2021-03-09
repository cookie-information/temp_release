//
//  PrivacyPopUpViewModel.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 19/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import Foundation

struct PrivacyPopUpData {
    let title: String
    let sections: [Section]
    let buttonViewModels: [PopUpButtonViewModelProtocol]
}

protocol PrivacyPopUpViewModelProtocol: AnyObject {
    var onLoadingChange: ((Bool) -> Void)? { get set }
    var onDataLoaded: ((PrivacyPopUpData) -> Void)? { get set }
    var onError: ((ErrorAlertModel) -> Void)? { get set }
    
    func viewDidLoad()
}

final class PrivacyPopUpViewModel: PrivacyPopUpViewModelProtocol {
    var onLoadingChange: ((Bool) -> Void)?
    var onDataLoaded: ((PrivacyPopUpData) -> Void)?
    var onError: ((ErrorAlertModel) -> Void)?
    
    var router: RouterProtocol?
    
    private let consentSolutionManager: ConsentSolutionManagerProtocol
    
    init(consentSolutionManager: ConsentSolutionManagerProtocol) {
        self.consentSolutionManager = consentSolutionManager
    }
    
    func viewDidLoad() {
        loadConsentSolution()
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
            
            let title = solution.title.primaryTranslation()?.text ?? ""
            let descriptionSection = PopUpDescriptionSection(text: solution.description.primaryTranslation()?.text ?? "")
            
            let consentViewModels = self.consentViewModels(from: solution)
            let consentsSection = PopUpConsentsSection(viewModels: consentViewModels)
            
            let data = PrivacyPopUpData(
                title: title,
                sections: [
                    descriptionSection,
                    consentsSection
                ],
                buttonViewModels: self.buttonViewModels(templateTexts: solution.templateTexts)
            )
        
            self.onDataLoaded?(data)
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
    
    private func consentViewModels(from solution: ConsentSolution) -> [PopUpConsentViewModel] {
        solution
            .consentItems
            .filter { $0.type == .setting }
            .map { item in
                let vm = PopUpConsentViewModel(
                    id: item.id,
                    text: item.translations.primaryTranslation()?.shortText ?? "",
                    isRequired: item.required,
                    consentItemProvider: consentSolutionManager
                )
                
                return vm
            }
    }
    
    private func buttonViewModels(templateTexts: TemplateTexts) -> [PopUpButtonViewModelProtocol] {
        let viewModels = [
            PopUpButtonViewModel(
                title: templateTexts.privacyCenterButton.primaryTranslation()?.text ?? "",
                type: .privacyCenter,
                stateProvider: ConstantButtonStateProvider(isEnabled: true)
            ),
            PopUpButtonViewModel(
                title: templateTexts.rejectAllButton.primaryTranslation()?.text ?? "",
                type: .rejectAll,
                stateProvider: ConstantButtonStateProvider(isEnabled: !consentSolutionManager.hasRequiredConsentItems)
            ),
            PopUpButtonViewModel(
                title: templateTexts.acceptAllButton.primaryTranslation()?.text ?? "",
                type: .acceptAll,
                stateProvider: ConstantButtonStateProvider(isEnabled: true)
            ),
            PopUpButtonViewModel(
                title: templateTexts.acceptSelectedButton.primaryTranslation()?.text ?? "",
                type: .acceptSelected,
                stateProvider: NotificationButtonStateProvider(
                    isEnabled: { [consentSolutionManager] in consentSolutionManager.areAllRequiredConsentItemsSelected },
                    notificationName: ConsentSolutionManager.consentItemSelectionDidChange
                )
            )
        ]
        
        viewModels.forEach { $0.delegate = self }
        
        return viewModels
    }
    
    private func handlePostingConsent(buttonType: PopUpButtonViewModel.ButtonType, error: Error?) {
        onLoadingChange?(false)
        
        if error == nil {
            router?.closeAll()
        } else {
            onError?(.init(
                retryHandler: { [weak self] in
                    self?.buttonTapped(type: buttonType)
                },
                cancelHandler: nil
            ))
        }
    }
}

extension PrivacyPopUpViewModel: PopUpButtonViewModelDelegate {
    func buttonTapped(type: PopUpButtonViewModel.ButtonType) {
        switch type {
        case .privacyCenter:
            router?.showPrivacyCenter(animated: true)
        case .rejectAll:
            onLoadingChange?(true)
            consentSolutionManager.rejectAllConsentItems { [weak self] error in
                self?.handlePostingConsent(buttonType: type, error: error)
            }
        case .acceptAll:
            onLoadingChange?(true)
            consentSolutionManager.acceptAllConsentItems { [weak self] error in
                self?.handlePostingConsent(buttonType: type, error: error)
            }
        case .acceptSelected:
            onLoadingChange?(true)
            consentSolutionManager.acceptSelectedConsentItems { [weak self] error in
                self?.handlePostingConsent(buttonType: type, error: error)
            }
        }
    }
}
