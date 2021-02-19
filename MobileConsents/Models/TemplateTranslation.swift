//
//  TemplateTranslation.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 15/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

public struct TemplateTranslation: Decodable, Translation, Equatable {
    public let language: String
    public let text: String
}
