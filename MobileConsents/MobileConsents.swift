//
//  MobileConsentsSDK.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 22/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import UIKit

protocol MobileConsentsProtocol {
    func fetchConsentSolution(forUniversalConsentSolutionId universalConsentSolutionId: String, completion:@escaping (Result<ConsentSolution, Error>) -> Void)
    
    func postConsent(_ consent: Consent, completion:@escaping (Error?) -> Void)
}

public final class MobileConsents: MobileConsentsProtocol {
    private let networkManager: NetworkManager
    private let localStorageManager: LocalStorageManager
    
    public typealias ConsentSolutionCompletion = (Result<ConsentSolution, Error>) -> Void
    
    /// MobileConsents class initializer.
    ///
    /// - Parameters:
    ///   - url: URL to server where Consents will be posted
    ///   - locale: Locale used for translations. Defaults to `Locale.autoupdatingCurrent`
    public convenience init(withBaseURL url: URL, locale: Locale = .autoupdatingCurrent) {
        self.init(withBaseURL: url, localStorageManager: LocalStorageManager(), locale: locale)
    }
    
    init(withBaseURL url: URL, localStorageManager: LocalStorageManager, locale: Locale) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.userInfo[translationLocale] = locale
        
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
    
    public static func showPrivacyCenter() {
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        
        let consentSolutionManager = ConsentSolutionManager(
            consentSolutionId: "1234",
            mobileConsents: MockMobileConsents() // TODO: Pass self as mobile consents
        )
        let viewModel = PrivacyCenterViewModel(consentSolutionManager: consentSolutionManager)
        let viewController = UINavigationController(rootViewController: PrivacyCenterViewController(viewModel: viewModel))
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .white
            viewController.navigationBar.standardAppearance = appearance
        } else {
            viewController.navigationBar.backgroundColor = .white
        }
        viewController.modalPresentationStyle = .fullScreen
        
        keyWindow?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    public static func showPrivacyPopUp() {
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        
        let consentSolutionManager = ConsentSolutionManager(
            consentSolutionId: "1234",
            mobileConsents: MockMobileConsents() // TODO: Pass self as mobile consents
        )
        let router = Router(consentSolutionManager: consentSolutionManager)
        let viewModel = PrivacyPopUpViewModel(consentSolutionManager: consentSolutionManager)
        
        viewModel.router = router
        let viewController = PrivacyPopUpViewController(viewModel: viewModel)
        router.rootViewController = viewController
        
        keyWindow?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
}

extension MobileConsents {
    func saveConsentResult(_ consent: Consent) {
        let consents = consent.processingPurposes.map({ [$0.consentItemId: $0.consentGiven] })
        localStorageManager.addConsentsArray(consents)
    }
}
