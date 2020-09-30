//
//  ConsentItem.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 24/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

public struct ConsentItem: Codable {
    public let id: String
    public let translations: [ConsentTranslation]
}
