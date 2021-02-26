//
//  Translated.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 15/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import Foundation

public protocol Translation {
    var language: String { get }
}

let translationLocale = CodingUserInfoKey(rawValue: "locale")!

public struct Translated<T: Translation & Decodable & Equatable>: Decodable, Equatable {
    public let translations: [T]
    private let locale: Locale?
    
    var currentLanguage: String {
        localeTranslation()?.language ?? "EN"
    }
    
    init(translations: [T], locale: Locale?) {
        self.translations = translations
        self.locale = locale
    }

    public init(from decoder: Decoder) throws {
        self.translations = try [T](from: decoder)
        self.locale = decoder.userInfo[translationLocale] as? Locale
    }
    
    public func translation(with locale: Locale) -> T? {
        translations.first { $0.language.uppercased() == locale.languageCode?.uppercased() }
    }
    
    public func localeTranslation() -> T? {
        locale.flatMap(translation(with:)) ?? translation(with: Locale(identifier: "EN"))
    }
}
