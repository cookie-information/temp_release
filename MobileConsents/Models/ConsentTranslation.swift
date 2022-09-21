//
//  ConsentTranslation.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 25/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

public struct ConsentTranslation: Codable, Translation, Equatable {
    public let language: String
    public let shortText: String
    public let longText: String
}
