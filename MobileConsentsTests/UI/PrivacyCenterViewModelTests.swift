//
//  PrivacyCenterViewModelTests.swift
//  MobileConsentsSDKTests
//
//  Created by Sebastian Osiński on 02/03/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

@testable import MobileConsentsSDK
import XCTest

final class PrivacyCenterViewModelTests: XCTestCase {
    private var sut: PrivacyCenterViewModel!
    private var consentSolutionManager: ConsentSolutionManagerMock!
    private var router: RouterMock!
    private var notificationCenter: NotificationCenter!
    private var isLoading: Bool?
    private var isAcceptButtonEnabled: Bool?
    private var loadedData: PrivacyCenterData?
    private var errorAlert: ErrorAlertModel?
    
    private let sampleError = NSError(domain: "Sample", code: 1234)
    
    override func setUp() {
        consentSolutionManager = ConsentSolutionManagerMock()
        router = RouterMock()
        notificationCenter = .default
        
        sut = PrivacyCenterViewModel(
            consentSolutionManager: consentSolutionManager,
            notificationCenter: notificationCenter
        )
        
        sut.onLoadingChange = { [weak self] isLoading in
            self?.isLoading = isLoading
        }
        
        sut.onAcceptButtonIsEnabledChange = { [weak self] isEnabled in
            self?.isAcceptButtonEnabled = isEnabled
        }
        
        sut.onDataLoaded = { [weak self] data in
            self?.loadedData = data
        }
        
        sut.onError = { [weak self] alert in
            self?.errorAlert = alert
        }
        
        sut.router = router
        
        isLoading = nil
        errorAlert = nil
    }
    
    func test_itIsLoading_afterViewLoads() {
        sut.viewDidLoad()
        
        XCTAssertTrue(try XCTUnwrap(isLoading))
    }
    
    func test_itIsNotLoading_afterConsentSolutionLoads() {
        sut.viewDidLoad()
        
        consentSolutionManager.loadConsentSolutionIfNeededCompletion?(.success(consentSolution(consentItemConfigs: [])))
        
        XCTAssertFalse(try XCTUnwrap(isLoading))
    }
    
    func test_loadedDataIsCorrect() throws {
        let solution = consentSolution(consentItemConfigs: [])
        
        sut.viewDidLoad()
        
        consentSolutionManager.loadConsentSolutionIfNeededCompletion?(.success(solution))
        
        let data = try XCTUnwrap(loadedData)
        
        XCTAssertEqual(data.translations.title, solution.templateTexts.privacyCenterTitle.primaryTranslation()?.text)
        XCTAssertEqual(data.translations.acceptButtonTitle, solution.templateTexts.savePreferencesButton.primaryTranslation()?.text)
    }
    
    func test_errorAlertIsShownAfterConsentSolutionFailsToLoad() {
        sut.viewDidLoad()
        
        consentSolutionManager.loadConsentSolutionIfNeededCompletion?(.failure(sampleError))
        
        XCTAssertNotNil(errorAlert)
    }
    
    func test_consentSolutionIsLoadedAgainAfterRetry() {
        sut.viewDidLoad()
        
        consentSolutionManager.loadConsentSolutionIfNeededCompletion?(.failure(sampleError))
        
        errorAlert?.retryHandler()
        
        consentSolutionManager.loadConsentSolutionIfNeededCompletion?(.success(consentSolution(consentItemConfigs: [])))
        
        XCTAssertNotNil(loadedData)
    }
    
    func test_cancellingConsentSolutionLoadingRetryCloses() {
        sut.viewDidLoad()
        
        consentSolutionManager.loadConsentSolutionIfNeededCompletion?(.failure(sampleError))
        
        errorAlert?.cancelHandler?()
        
        XCTAssertTrue(router.closeAllCalled)
    }
    
    func test_acceptButtonIsEnabled_whenLoadedSolutionHasAllRequiredConsentsSelected() {
        consentSolutionManager.areAllRequiredConsentItemsSelected = true
        
        sut.viewDidLoad()
        
        consentSolutionManager.loadConsentSolutionIfNeededCompletion?(.success(consentSolution(consentItemConfigs: [])))
        
        XCTAssertTrue(try XCTUnwrap(isAcceptButtonEnabled))
    }
    
    func test_acceptButtonIsDisabled_whenLoadedSolutionDoesNotHaveAllRequiredConsentsSelected() {
        consentSolutionManager.areAllRequiredConsentItemsSelected = false
        
        sut.viewDidLoad()
        
        consentSolutionManager.loadConsentSolutionIfNeededCompletion?(.success(consentSolution(consentItemConfigs: [])))
        
        XCTAssertFalse(try XCTUnwrap(isAcceptButtonEnabled))
    }
    
    func test_acceptButtonStateIsUpdated_whenNotificationIsPosted() {
        sut.viewDidLoad()
        
        consentSolutionManager.areAllRequiredConsentItemsSelected = true
        notificationCenter.post(.init(name: ConsentSolutionManager.consentItemSelectionDidChange))
        
        XCTAssertTrue(try XCTUnwrap(isAcceptButtonEnabled))
        
        consentSolutionManager.areAllRequiredConsentItemsSelected = false
        notificationCenter.post(.init(name: ConsentSolutionManager.consentItemSelectionDidChange))
        
        XCTAssertFalse(try XCTUnwrap(isAcceptButtonEnabled))
    }
    
    func test_tappingBackButtonClosesPrivacyCenter() {
        sut.backButtonTapped()
        
        XCTAssertTrue(router.closePrivacyCenterCalled)
    }
    
    func test_tappingAcceptButtonShowsLoading() {
        sut.acceptButtonTapped()
        
        XCTAssertTrue(try XCTUnwrap(isLoading))
    }
    
    func test_itIsNotLoading_afterAcceptingConsentItemsFinishesWithSuccess() {
        sut.acceptButtonTapped()
        
        consentSolutionManager.completion?(nil)
        
        XCTAssertFalse(try XCTUnwrap(isLoading))
    }
    
    func test_itIsNotLoading_afterAcceptingConsentItemsFinishesWithError() {
        sut.acceptButtonTapped()
        
        consentSolutionManager.completion?(sampleError)
        
        XCTAssertFalse(try XCTUnwrap(isLoading))
    }
    
    func test_alertIsShown_afterAcceptingConsentItemsFinishesWithError() {
        sut.acceptButtonTapped()
        
        consentSolutionManager.completion?(sampleError)
        
        XCTAssertNotNil(errorAlert)
    }
    
    func test_acceptingConsentsIsRetries_afterRetryButtonIsTapped() {
        sut.acceptButtonTapped()
        
        consentSolutionManager.completion?(sampleError)
        consentSolutionManager.completion = nil
        
        errorAlert?.retryHandler()
        
        XCTAssertNotNil(consentSolutionManager.completion)
    }
}
