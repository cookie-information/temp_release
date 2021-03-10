//
//  TemplateTexts.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 15/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

public struct TemplateTexts: Decodable, Equatable {
    public let privacyCenterButton: Translated<TemplateTranslation>
    public let rejectAllButton: Translated<TemplateTranslation>
    public let acceptAllButton: Translated<TemplateTranslation>
    public let acceptSelectedButton: Translated<TemplateTranslation>
    public let savePreferencesButton: Translated<TemplateTranslation>
    public let privacyCenterTitle: Translated<TemplateTranslation>
    public let privacyPreferencesTabLabel: Translated<TemplateTranslation>
    public let poweredByCoiLabel: Translated<TemplateTranslation>
    public let consentPreferencesLabel: Translated<TemplateTranslation>
}
