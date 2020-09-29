//
//  MobileConsentsSDK.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 22/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation
import UIKit

public final class MobileConsentsSDK {
    var environment: Environment = .staging
    
    private let networkManager: NetworkManager
    
    public typealias ConsentSolutionCompletion = (ConsentSolution?, Error?) -> Void
    
    public init(withBaseURL url: URL) {
        self.networkManager = NetworkManager(withBaseURL: url)
        systemInfo()
    }
    
    public func fetchConsentSolution(forUniversalConsentSolutionId universalConsentSolutionId: String, completion:@escaping ConsentSolutionCompletion ) {
        networkManager.getConsents(forUUID: universalConsentSolutionId, completion: completion)
    }
    
    public func postConsent(_ consent: Consent, completion:@escaping (Error?) -> Void) {
        // TODO: to be implemented
    }
    
    public func cancel() {
        networkManager.cancel()
    }
}


extension MobileConsentsSDK {
    func systemInfo() {
        let systemVersion = UIDevice.current.systemVersion
        print("OS version: iOS ", systemVersion)
        
        let bundeID = Bundle.main.bundleIdentifier
        print("Bundle identifier: ", bundeID!)
        
        let appname = Bundle.main.object(forInfoDictionaryKey: "CFBundleName")
        print("App name: ", appname!)
    }
}
