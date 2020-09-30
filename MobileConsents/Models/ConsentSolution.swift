//
//  ConsentSolution.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 25/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

public struct ConsentSolution: Codable {
    public let id: String
    public let versionId: String
    public let consentItems: [ConsentItem]
}
