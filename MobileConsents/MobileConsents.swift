//
//  MobileConsentsSDK.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 22/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import UIKit

protocol MobileConsentsProtocol {
    func fetchConsentSolution(forUniversalConsentSolutionId universalConsentSolutionId: String, completion: @escaping (Result<ConsentSolution, Error>) -> Void)
    func postConsent(_ consent: Consent, completion: @escaping (Error?) -> Void)
    func getSavedConsents() -> [SavedConsent]
}

public final class MobileConsents: MobileConsentsProtocol {
    private let networkManager: NetworkManager
    private let localStorageManager: LocalStorageManager
    
    public typealias ConsentSolutionCompletion = (Result<ConsentSolution, Error>) -> Void
    
    /// MobileConsents class initializer.
    ///
    /// - Parameters:
    ///   - url: URL to server where Consents will be posted
    ///   - uiLanguageCode: Language code used for translations in built-in privacy screens. If not provided, current app language is used. If translations are not available in given language, English is used.
    public convenience init(withBaseURL url: URL, uiLanguageCode: String? = Bundle.main.preferredLocalizations.first) {
        self.init(withBaseURL: url, localStorageManager: LocalStorageManager(), uiLanguageCode: uiLanguageCode)
    }
    
    init(withBaseURL url: URL, localStorageManager: LocalStorageManager, uiLanguageCode: String?) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.userInfo[primaryLanguageCodingUserInfoKey] = uiLanguageCode
        
        self.networkManager = NetworkManager(
            withBaseURL: url,
            jsonDecoder: jsonDecoder,
            localStorageManager: localStorageManager
        )
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
    
    /// Method responsible for showing Privacy Pop Up screen
    /// - Parameters:
    ///   - universalConsentSolutionId: Consent Solution identifier
    ///   - presentingViewController: UIViewController to present pop up on. If not provided, top-most presented view controller of key window of the application is used.
    ///   - animated: If presentation should be animated. Defaults to `true`.
    public func showPrivacyPopUp(
        forUniversalConsentSolutionId universalConsentSolutionId: String,
        onViewController presentingViewController: UIViewController? = nil,
        animated: Bool = true
    ) {
        let presentingViewController = presentingViewController ?? UIApplication.shared.windows.first { $0.isKeyWindow }?.topViewController
        
        let consentSolutionManager = ConsentSolutionManager(
            consentSolutionId: universalConsentSolutionId,
            mobileConsents: self
        )
        
        let router = Router(consentSolutionManager: consentSolutionManager)
        router.rootViewController = presentingViewController
        
        router.showPrivacyPopUp(animated: animated)
    }
    
    /// Method responsible for showing Privacy Preferences Center screen
    /// - Parameters:
    ///   - universalConsentSolutionId: Consent Solution identifier
    ///   - presentingViewController: UIViewController to present preferences center on.. If not provided, top-most presented view controller of key window of the application is used.
    ///   - animated:If presentation should be animated. Defaults to `true`.
    public func showPrivacyCenter(
        forUniversalConsentSolutionId universalConsentSolutionId: String,
        onViewController presentingViewController: UIViewController? = nil,
        animated: Bool = true
    ) {
        let presentingViewController = presentingViewController ?? UIApplication.shared.windows.first { $0.isKeyWindow }?.topViewController
        
        let consentSolutionManager = ConsentSolutionManager(
            consentSolutionId: universalConsentSolutionId,
            mobileConsents: self
        )
        
        let router = Router(consentSolutionManager: consentSolutionManager)
        router.rootViewController = presentingViewController
        
        router.showPrivacyCenter(animated: animated)
    }
}

extension MobileConsents {
    func saveConsentResult(_ consent: Consent) {
        let consents = consent.processingPurposes.map({ [$0.consentItemId: $0.consentGiven] })
        localStorageManager.addConsentsArray(consents)
    }
}
