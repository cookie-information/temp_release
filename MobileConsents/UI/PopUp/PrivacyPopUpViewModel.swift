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
    
    func viewDidLoad() {
        let solution = mockConsentSolution
        
        let title = solution.title.localeTranslation()?.text ?? ""
        let descriptionSection = PopUpDescriptionSection(text: solution.description.localeTranslation()?.text ?? "")
        
        let consentViewModels: [PopUpConsentViewModel] = solution
            .consentItems
            .filter { $0.type == .setting }
            .map { item in
                let vm = PopUpConsentViewModel(
                    id: item.id,
                    text: item.translations.localeTranslation()?.longText ?? "",
                    isRequired: item.required
                )
                vm.delegate = self
                
                return vm
            }
        
        let consentsSection = PopUpConsentsSection(viewModels: consentViewModels)
        
        let data = PrivacyPopUpData(
            title: title,
            sections: [
                descriptionSection,
                consentsSection
            ],
            buttonViewModels: buttonViewModels(templateTexts: solution.templateTexts)
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.onDataLoaded?(data)
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

extension PrivacyPopUpViewModel: PopUpConsentViewModelDelegate {
    func consentSelectionDidChange(id: String, isSelected: Bool) {
        print("Item \(id) selection changed to: \(isSelected)")
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
