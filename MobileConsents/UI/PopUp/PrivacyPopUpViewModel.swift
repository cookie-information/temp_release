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
    
    func viewDidLoad() {
        let solution = mockConsentSolution
        
        let title = solution.title.localeTranslation()?.text ?? ""
        let descriptionSection = PopUpDescriptionSection(text: solution.description.localeTranslation()?.text ?? "")
        
        let consentViewModels: [PopUpConsentViewModel] = solution
            .consentItems
            .filter { $0.type == .setting }
            .map { item in
                PopUpConsentViewModel(
                    text: item.translations.localeTranslation()?.longText ?? "",
                    isRequired: item.required
                )
            }
        
        let consentsSection = PopUpConsentsSection(viewModels: consentViewModels)
        
        let buttonViewModels: [PopUpButtonViewModelProtocol] = [
            PopUpButtonViewModel(title: solution.templateTexts.privacyCenterButton.localeTranslation()?.text ?? "", color: .popUpButton1),
            PopUpButtonViewModel(title: solution.templateTexts.rejectAllButton.localeTranslation()?.text ?? "", color: .popUpButton1),
            PopUpButtonViewModel(title: solution.templateTexts.acceptAllButton.localeTranslation()?.text ?? "", color: .popUpButton2),
            PopUpButtonViewModel(title: solution.templateTexts.acceptSelectedButton.localeTranslation()?.text ?? "", color: .popUpButton2)
        ]
        
        let data = PrivacyPopUpData(
            title: title,
            sections: [
                descriptionSection,
                consentsSection
            ],
            buttonViewModels: buttonViewModels
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.onDataLoaded?(data)
        }
    }
}
