//
//  MobileConsentsSDK.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 22/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import UIKit

public final class MobileConsents {
    var environment: Environment = .staging
    
    private let networkManager: NetworkManager
    private let localStorageManager: LocalStorageManager
    
    public typealias ConsentSolutionCompletion = (Result<ConsentSolution, Error>) -> Void
    
    public convenience init(withBaseURL url: URL) {
        self.init(withBaseURL: url, localStorageManager: LocalStorageManager())
    }
    
    init(withBaseURL url: URL, localStorageManager: LocalStorageManager) {
        self.localStorageManager = localStorageManager
        self.networkManager = NetworkManager(withBaseURL: url, localStorageManager: self.localStorageManager)
    }
    
    public func fetchConsentSolution(forUniversalConsentSolutionId universalConsentSolutionId: String, completion:@escaping ConsentSolutionCompletion) {
        networkManager.getConsentSolution(forUUID: universalConsentSolutionId, completion: completion)
    }
    
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
    
    public func getSavedConsents() -> [SavedConsent] {
        let savedData = localStorageManager.consents
        return savedData.map { SavedConsent(consentItemId: $0.key, consentGiven: $0.value) }
    }
    
    public func cancel() {
        networkManager.cancel()
    }
}

extension MobileConsents {
    func saveConsentResult(_ consent: Consent) {
        let consents = consent.processingPurposes.map({ [$0.consentItemId: $0.consentGiven] })
        localStorageManager.addConsentsArray(consents)
    }
}
