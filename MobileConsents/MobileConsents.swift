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
    func getSavedConsents() -> [UserConsent]
}

public final class MobileConsents: MobileConsentsProtocol {
    private let networkManager: NetworkManager
    private let localStorageManager: LocalStorageManager
    
    private let accentColor: UIColor
    public typealias ConsentSolutionCompletion = (Result<ConsentSolution, Error>) -> ()
    
    /// MobileConsents class initializer.
    ///
    /// - Parameters:
    ///   - uiLanguageCode: Language code used for translations in built-in privacy screens. If not provided, current app language is used. If translations are not available in given language, English is used.
    ///   - clientID: the client identifier, can be obtained from Cookie Information dashboard
    ///   - clientSecret: the client secret, can be obtained from Cookie Information dashboard
    public convenience init(uiLanguageCode: String? = Bundle.main.preferredLocalizations.first, clientID: String, clientSecret: String, accentColor: UIColor? = nil) {
        self.init(localStorageManager: LocalStorageManager(), uiLanguageCode: uiLanguageCode, clientID: clientID, clientSecret: clientSecret, accentColor: accentColor)
    }
    
    init(localStorageManager: LocalStorageManager, uiLanguageCode: String?, clientID: String, clientSecret: String, accentColor: UIColor? = nil) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.userInfo[primaryLanguageCodingUserInfoKey] = uiLanguageCode
        
        
        self.accentColor = accentColor ?? .systemBlue
        
        
        self.networkManager = NetworkManager(
            jsonDecoder: jsonDecoder,
            localStorageManager: localStorageManager,
            clientID: clientID,
            clientSecret: clientSecret
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
    public func getSavedConsents() -> [UserConsent] {
        localStorageManager.consents.map {$0.value}
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
    ///   - completion: called after the user closes the privacy popup.
    public func showPrivacyPopUp(
        forUniversalConsentSolutionId universalConsentSolutionId: String,
        onViewController presentingViewController: UIViewController? = nil,
        animated: Bool = true,
        completion: (([UserConsent])->())? = nil
    ) {
        let presentingViewController = presentingViewController ?? UIApplication.shared.windows.first { $0.isKeyWindow }?.topViewController
        
        let consentSolutionManager = ConsentSolutionManager(
            consentSolutionId: universalConsentSolutionId,
            mobileConsents: self
        )
        
        let router = Router(consentSolutionManager: consentSolutionManager, accentColor: accentColor)
        router.rootViewController = presentingViewController
        
        router.showPrivacyPopUp(animated: animated, completion: completion)
        
    }
    
    
    /// Method responsible for showing Privacy Pop Up screen if there has not been a consent recorded or if the consent
    /// - Parameters:
    ///   - universalConsentSolutionId: Consent Solution identifier
    ///   - presentingViewController: UIViewController to present pop up on. If not provided, top-most presented view controller of key window of the application is used.
    ///   - animated: If presentation should be animated. Defaults to `true`.
    ///   - completion: called after the user closes the privacy popup.
    public func showPrivacyPopUpIfNeeded(
        forUniversalConsentSolutionId universalConsentSolutionId: String,
        onViewController presentingViewController: UIViewController? = nil,
        animated: Bool = true,
        completion: (([UserConsent])->())? = nil
    ) {
        guard !localStorageManager.consents.isEmpty else {
            showPrivacyPopUp(forUniversalConsentSolutionId: universalConsentSolutionId, completion: completion)
            return
        }
        let consents = localStorageManager.consents
        let userConsents = consents.map(\.value)
        completion?(userConsents)
    }
    
}

extension MobileConsents {
    func saveConsentResult(_ consent: Consent) {
        let consents = consent.userConsents
        localStorageManager.addConsentsArray(consents)
    }
}
