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
    var onDataLoaded: ((PrivacyPopUpData) -> Void)? { get set }
    
    func viewDidLoad()
}

final class PrivacyPopUpViewModel: PrivacyPopUpViewModelProtocol {
    var onDataLoaded: ((PrivacyPopUpData) -> Void)?
    
    var router: RouterProtocol?
    
    private let consentSolutionManager: ConsentSolutionManagerProtocol
    
    init(consentSolutionManager: ConsentSolutionManagerProtocol) {
        self.consentSolutionManager = consentSolutionManager
    }
    
    func viewDidLoad() {
        consentSolutionManager.loadConsentSolutionIfNeeded { result in
            guard case .success(let solution) = result else { return }
            
            let title = solution.title.localeTranslation()?.text ?? ""
            let descriptionSection = PopUpDescriptionSection(text: solution.description.localeTranslation()?.text ?? "")
            
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
    
    private func consentViewModels(from solution: ConsentSolution) -> [PopUpConsentViewModel] {
        solution
            .consentItems
            .filter { $0.type == .setting }
            .map { item in
                let vm = PopUpConsentViewModel(
                    id: item.id,
                    text: item.translations.localeTranslation()?.longText ?? "",
                    isRequired: item.required,
                    consentItemProvider: consentSolutionManager
                )
                
                return vm
            }
    }
    
    private func buttonViewModels(templateTexts: TemplateTexts) -> [PopUpButtonViewModelProtocol] {
        let viewModels = [
            PopUpButtonViewModel(
                title: templateTexts.privacyCenterButton.localeTranslation()?.text ?? "",
                color: .popUpButton1,
                type: .privacyCenter
            ),
            PopUpButtonViewModel(
                title: templateTexts.rejectAllButton.localeTranslation()?.text ?? "",
                color: .popUpButton1,
                type: .rejectAll
            ),
            PopUpButtonViewModel(
                title: templateTexts.acceptAllButton.localeTranslation()?.text ?? "",
                color: .popUpButton2,
                type: .acceptAll
            ),
            PopUpButtonViewModel(
                title: templateTexts.acceptSelectedButton.localeTranslation()?.text ?? "",
                color: .popUpButton2,
                type: .acceptSelected
            )
        ]
        
        viewModels.forEach { $0.delegate = self }
        
        return viewModels
    }
}

extension PrivacyPopUpViewModel: PopUpButtonViewModelDelegate {
    func buttonTapped(type: PopUpButtonViewModel.ButtonType) {
        print("Button \(type) tapped")
        
        switch type {
        case .privacyCenter:
            router?.showPrivacyCenter()
        default:
            ()
        }
    }
}
