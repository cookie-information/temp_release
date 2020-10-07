//
//  PlatformInformation.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 05/10/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import UIKit

protocol PlatformInformationGeneratorProtocol {
    func generatePlatformInformation() -> [String: String]
}

struct PlatformInformationGenerator: PlatformInformationGeneratorProtocol {
    func generatePlatformInformation() -> [String: String] {
        return [
            "operatingSystem": UIDevice.current.systemVersion,
            "applicationId": Bundle.main.bundleIdentifier ?? "",
            "applicationName": Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
        ]
    }
}
