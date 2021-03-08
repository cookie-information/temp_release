//
//  PrivacyPopUpViewModelTests.swift
//  MobileConsentsSDKTests
//
//  Created by Sebastian Osiński on 26/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import XCTest
@testable import MobileConsentsSDK

class PrivacyPopUpViewModelTests: XCTestCase {
    var sut: PrivacyPopUpViewModel!
    var consentSolutionManager: ConsentSolutionManagerMock!
    var router: RouterMock!
    
    var isLoading: Bool?
    var loadedData: PrivacyPopUpData?

    override func setUpWithError() throws {
        consentSolutionManager = ConsentSolutionManagerMock()
        router = RouterMock()
        sut = PrivacyPopUpViewModel(
            consentSolutionManager: consentSolutionManager
        )
        sut.router = router
        isLoading = nil
        
        sut.onLoadingChange = { [weak self] isLoading in
            self?.isLoading = isLoading
        }
        
        sut.onDataLoaded = { [weak self] data in
            self?.loadedData = data
        }
    }
    
    func test_viewDidLoadShowsLoader() {
        sut.viewDidLoad()
        
        XCTAssertTrue(try XCTUnwrap(isLoading))
    }
    
    func test_loaderIsHiddenAfterLoadingConsentSolutionFinishes() {
        sut.viewDidLoad()
        
        consentSolutionManager.loadConsentSolutionIfNeededCompletion?(.success(consentSolution(consentItemConfigs: [])))
        
        XCTAssertFalse(try XCTUnwrap(isLoading))
    }
    
    func test_dataIsLoadedAfterLoadingConsentSolutionFinishes() {
        sut.viewDidLoad()
        
        consentSolutionManager.loadConsentSolutionIfNeededCompletion?(.success(consentSolution(consentItemConfigs: [])))
        
        XCTAssertNotNil(loadedData)
    }
    
    func test_loadedDataIsCorrect() throws {
        sut.viewDidLoad()
        
        let solution = consentSolution(consentItemConfigs: [])
        
        consentSolutionManager.loadConsentSolutionIfNeededCompletion?(.success(solution))
        
        let data = try XCTUnwrap(loadedData)
        
        XCTAssertEqual(data.title, solution.title.primaryTranslation()?.text)
        
        XCTAssertEqual(data.buttonViewModels.count, 4)
    }
    
    func test_tappingPrivacyCenterButtonShowsPrivacyCenter() {
        sut.buttonTapped(type: .privacyCenter)
        
        XCTAssertTrue(router.showPrivacyCenterCalled)
    }
    
    func test_tappingRejectAllButtonShowsLoaderAndHidesItAfterFinish() {
        sut.buttonTapped(type: .rejectAll)
        
        XCTAssertTrue(try XCTUnwrap(isLoading))
        
        consentSolutionManager.completion?(nil)
        
        XCTAssertFalse(try XCTUnwrap(isLoading))
    }
    
    func test_tappingRejectAllClosesAfterSuccessfulFinish() {
        sut.buttonTapped(type: .rejectAll)
        
        consentSolutionManager.completion?(nil)
        
        XCTAssertTrue(router.closeAllCalled)
    }
    
    func test_tappingAcceptAllButtonShowsLoaderAndHidesItAfterFinish() {
        sut.buttonTapped(type: .acceptAll)
        
        XCTAssertTrue(try XCTUnwrap(isLoading))
        
        consentSolutionManager.completion?(nil)
        
        XCTAssertFalse(try XCTUnwrap(isLoading))
    }
    
    func test_tappingAcceptAllClosesAfterSuccessfulFinish() {
        sut.buttonTapped(type: .acceptAll)
        
        consentSolutionManager.completion?(nil)
        
        XCTAssertTrue(router.closeAllCalled)
    }
    
    func test_tappingAcceptSelectedButtonShowsLoaderAndHidesItAfterFinish() {
        sut.buttonTapped(type: .acceptSelected)
        
        XCTAssertTrue(try XCTUnwrap(isLoading))
        
        consentSolutionManager.completion?(nil)
        
        XCTAssertFalse(try XCTUnwrap(isLoading))
    }
    
    func test_tappingAcceptSelectedClosesAfterSuccessfulFinish() {
        sut.buttonTapped(type: .acceptSelected)
        
        consentSolutionManager.completion?(nil)
        
        XCTAssertTrue(router.closeAllCalled)
    }
}

final class ConsentSolutionManagerMock: ConsentSolutionManagerProtocol {
    var areAllRequiredConsentItemsSelected = false
    var hasRequiredConsentItems = true
    var consentItemSelections = [String: Bool]()
    
    var loadConsentSolutionIfNeededCompletion: ((Result<ConsentSolution, Error>) -> Void)?
    
    var completion: ((Error?) -> Void)?
    
    func loadConsentSolutionIfNeeded(completion: @escaping (Result<ConsentSolution, Error>) -> Void) {
        loadConsentSolutionIfNeededCompletion = completion
    }
    
    func rejectAllConsentItems(completion: @escaping (Error?) -> Void) {
        self.completion = completion
    }
    
    func acceptAllConsentItems(completion: @escaping (Error?) -> Void) {
        self.completion = completion
    }
    
    func acceptSelectedConsentItems(completion: @escaping (Error?) -> Void) {
        self.completion = completion
    }
    
    func isConsentItemSelected(id: String) -> Bool {
        consentItemSelections[id, default: false]
    }
    
    func markConsentItem(id: String, asSelected selected: Bool) {
        consentItemSelections[id] = selected
    }
}

final class RouterMock: RouterProtocol {
    private(set) var showPrivacyCenterCalled = false
    private(set) var closePrivacyCenterCalled = false
    private(set) var closeAllCalled = false
    
    func showPrivacyCenter(animated: Bool) {
        showPrivacyCenterCalled = true
    }
    
    func closePrivacyCenter() {
        closePrivacyCenterCalled = true
    }
    
    func closeAll() {
        closeAllCalled = true
    }
}
