//
//  MobileConsentsSDK.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 22/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import UIKit

public final class MobileConsents {
    var environment: Environment = .production
    
    private let networkManager: NetworkManager
    private let localStorageManager: LocalStorageManager
    
    public typealias ConsentSolutionCompletion = (Result<ConsentSolution, Error>) -> Void
    
    /// MobileConsents class initializer.
    ///
    /// - Parameters:
    ///   - url: URL to server where Consents will be posted
    public convenience init(withBaseURL url: URL) {
        self.init(withBaseURL: url, localStorageManager: LocalStorageManager())
    }
    
    init(withBaseURL url: URL, localStorageManager: LocalStorageManager) {        
        self.networkManager = NetworkManager(withBaseURL: url, localStorageManager: localStorageManager)
        self.localStorageManager = localStorageManager
    }
    
    /// Method responsible for fetching Consent Solutions.
    ///
    /// - Parameters:
    ///   - universalConsentSolutionId: Consent Solution identifier
    ///   - completion: callback - (Result<ConsentSolution, Error>) -> Void
    public func fetchConsentSolution(forUniversalConsentSolutionId universalConsentSolutionId: String, completion:@escaping ConsentSolutionCompletion) {
        networkManager.getConsentSolution(forUUID: universalConsentSolutionId, completion: completion)
    }
    
    /// Method responsible for posting Consent to server.
    ///
    /// - Parameters:
    ///   - consent: Consent object which will be send to server
    ///   - completion: callback - (Error?) -> Void)
    public func postConsent(_ consent: Consent, completion:@escaping (Error?) -> Void) {
        networkManager.postConsent(consent) {[weak self] error in
            if let error = error {
                completion(error)
            } else {
                self?.saveConsentResult(consent)
                completion(nil)
            }
        }
    }
    
    /// Method responsible for getting saved locally consents.
    ///
    /// Returns array of SavedConsent object
    public func getSavedConsents() -> [SavedConsent] {
        let savedData = localStorageManager.consents
        return savedData.map { SavedConsent(consentItemId: $0.key, consentGiven: $0.value) }
    }
    
    /// Method responsible for canceling last post consent request.
    ///
    public func cancel() {
        networkManager.cancel()
    }
    
    public static func showFullScreenConsents() {
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        
        keyWindow?.rootViewController?.present(PrivacyCenterViewController(), animated: true, completion: nil)
    }
}

extension MobileConsents {
    func saveConsentResult(_ consent: Consent) {
        let consents = consent.processingPurposes.map({ [$0.consentItemId: $0.consentGiven] })
        localStorageManager.addConsentsArray(consents)
    }
}
