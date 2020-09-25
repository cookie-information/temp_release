//
//  MobileConsents.swift
//  MobileConsents
//
//  Created by Jan Lipmann on 22/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation

public protocol MobileConsentsSDKDelegate: AnyObject {
    func mobileConsentsSDK(_ instance: MobileConsentsSDK, didFetchConsentSolution consentSolution: ConsentSolution)
    func mobileConsentsSDKDidPostConsentWithSuccess(_ instance: MobileConsentsSDK)
    func mobileConsentsSDKDidCancel(_ instance: MobileConsentsSDK)
    func mobileConsentsSDK(_ instance: MobileConsentsSDK, didRiseAnError error: Error)
}

public final class MobileConsentsSDK {
    var environment: Environment = .staging
    
    private let baseURL: URL
    private weak var delegate: MobileConsentsSDKDelegate?
    
    public init(withBaseURL url: URL, delegate: MobileConsentsSDKDelegate) {
        self.baseURL = url
        self.delegate = delegate
    }
    
    public func fetchConsentSolution(forUniversalConsentSolutionId universalConsentSolutionId: String, completion:@escaping (ConsentSolution?, Error?) -> Void) {
        // TODO: to be implemented
    }
    
    public func postConsent(_ consent: Consent, completion:@escaping (Error?) -> Void) {
        // TODO: to be implemented
    }
    
    public func cancel() {
        // TODO: to be implemented
    }
}
