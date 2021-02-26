//
//  ConsentSolutionManagerTests.swift
//  MobileConsentsSDKTests
//
//  Created by Sebastian Osiński on 23/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import XCTest
@testable import MobileConsentsSDK

final class ConsentSolutionManagerTests: XCTestCase {
    private var sut: ConsentSolutionManager!
    private var notificationCenter: NotificationCenter!
    private var mobileConsents: MobileConsentsMock!
    
    private var notificationCount: Int!
    private var observationToken: Any!
    
    override func setUp() {
        notificationCenter = .default
        mobileConsents = MobileConsentsMock()
        
        sut = ConsentSolutionManager(
            consentSolutionId: "TestConsentSolutionId",
            mobileConsents: mobileConsents,
            notificationCenter: notificationCenter,
            asyncDispatcher: DummyAsyncDispatcher()
        )
        
        notificationCount = 0
        
        observationToken = notificationCenter.addObserver(
            forName: ConsentSolutionManager.consentItemSelectionDidChange,
            object: nil,
            queue: nil) { [weak self] _ in
            self?.notificationCount += 1
        }
    }
    
    override func tearDown() {
        sut = nil
        notificationCount = nil
        notificationCenter.removeObserver(observationToken as Any)
    }
    
    func test_areAllRequiredConsentItemsSelectedIsFalse_whenConsentSolutionIsNotLoaded() {
        XCTAssertFalse(sut.areAllRequiredConsentItemsSelected)
    }
    
    func test_hasRequiredConsentItemsIsFalse_whenConsentSolutionIsNotLoaded() {
        XCTAssertFalse(sut.hasRequiredConsentItems)
    }
    
    func test_allRequiredConsentItemsAreSelected_whenLoadedSolutionHasNoRequiredConsentItems() {
        loadConsentSolution(consentSolution(consentItemConfigs: [(false, .setting), (false, .setting)]))
        
        XCTAssertTrue(sut.areAllRequiredConsentItemsSelected)
    }
    
    func test_hasNoRequiredConsentItems_whenLoadedSolutionHasNoRequiredConsentItems() {
        loadConsentSolution(consentSolution(consentItemConfigs: [(false, .setting), (false, .setting)]))
        
        XCTAssertFalse(sut.hasRequiredConsentItems)
    }
    
    func test_allRequiredConsentItemsAreSelected_whenLoadedSolutionHasOnlyRequiredConsentItemsOfTypeInfo() {
        loadConsentSolution(consentSolution(consentItemConfigs: [(false, .setting), (true, .info)]))
        
        XCTAssertTrue(sut.areAllRequiredConsentItemsSelected)
    }
    
    func test_hasNoRequiredConsentItems_whenLoadedSolutionHasRequiredConsentItemsOfTypeInfo() {
        loadConsentSolution(consentSolution(consentItemConfigs: [(false, .setting), (true, .info)]))
        
        XCTAssertFalse(sut.hasRequiredConsentItems)
    }
    
    func test_allRequiredConsentItemsAreNotSelected_whenLoadedSolutionHasRequiredConsentItemsOfTypeSetting() {
        loadConsentSolution(consentSolution(consentItemConfigs: [(true, .setting)]))
        
        XCTAssertFalse(sut.areAllRequiredConsentItemsSelected)
    }
    
    func test_hasRequiredConsentItems_whenLoadedSolutionHasRequiredConsentItemsOfTypeSetting() {
        loadConsentSolution(consentSolution(consentItemConfigs: [(true, .setting)]))
        
        XCTAssertTrue(sut.hasRequiredConsentItems)
    }
    
    func test_consentItemIsNotSelected_afterLoadingConsentSolution() {
        loadConsentSolution(consentSolution(consentItemConfigs: [(true, .setting)]))
        
        XCTAssertFalse(sut.isConsentItemSelected(id: "0"))
    }
    
    func test_consentItemIsSelected_afterMarkingItAsSelected() {
        loadConsentSolution(consentSolution(consentItemConfigs: [(true, .setting)]))
        sut.markConsentItem(id: "0", asSelected: true)
        
        XCTAssertTrue(sut.isConsentItemSelected(id: "0"))
        XCTAssertEqual(notificationCount, 1)
    }
    
    func test_consentItemIsNotSelected_afterMarkingItAsNotSelected() {
        loadConsentSolution(consentSolution(consentItemConfigs: [(true, .setting)]))
        sut.markConsentItem(id: "0", asSelected: true)
        sut.markConsentItem(id: "0", asSelected: false)
        
        XCTAssertFalse(sut.isConsentItemSelected(id: "0"))
        XCTAssertEqual(notificationCount, 2)
    }
    
    func test_acceptAllConsentItemsMarksAllConsentsAsSelected() {
        loadConsentSolution(consentSolution(consentItemConfigs: [(true, .setting), (true, .setting)]))
        
        sut.acceptAllConsentItems { _ in }
        
        XCTAssertTrue(sut.isConsentItemSelected(id: "0"))
        XCTAssertTrue(sut.isConsentItemSelected(id: "1"))
        
        XCTAssertEqual(notificationCount, 1)
    }
    
    func test_acceptAllConsentItemsPostsAllConsentsAsGiven() throws {
        loadConsentSolution(consentSolution(consentItemConfigs: [(true, .setting), (false, .setting), (true, .info)]))
        
        sut.acceptAllConsentItems { _ in }
        
        let processingPurposes = try XCTUnwrap(mobileConsents.postedConsents?.processingPurposes)
        
        XCTAssertTrue(processingPurposes.first { $0.consentItemId == "0" }?.consentGiven ?? false)
        XCTAssertTrue(processingPurposes.first { $0.consentItemId == "1" }?.consentGiven ?? false)
        XCTAssertTrue(processingPurposes.first { $0.consentItemId == "2" }?.consentGiven ?? false)
    }
    
    func test_acceptSelectedConsentItemsPostsOnlySelectedConsentsAndInfoConsentsAsGiven() throws {
        loadConsentSolution(consentSolution(consentItemConfigs: [(true, .setting), (false, .setting), (true, .info)]))
        
        sut.markConsentItem(id: "0", asSelected: true)
        
        sut.acceptSelectedConsentItems { _ in }
        
        let processingPurposes = try XCTUnwrap(mobileConsents.postedConsents?.processingPurposes)
        
        XCTAssertTrue(processingPurposes.first { $0.consentItemId == "0" }?.consentGiven ?? false)
        XCTAssertFalse(processingPurposes.first { $0.consentItemId == "1" }?.consentGiven ?? true)
        XCTAssertTrue(processingPurposes.first { $0.consentItemId == "2" }?.consentGiven ?? false)
    }
    
    func test_rejectAllConsentItemsMarksAllConsentsAsNotSelected() {
        loadConsentSolution(consentSolution(consentItemConfigs: [(true, .setting), (true, .setting)]))
         
        sut.markConsentItem(id: "0", asSelected: false)
        sut.markConsentItem(id: "1", asSelected: false)
        
        sut.rejectAllConsentItems { _ in }
        
        XCTAssertFalse(sut.isConsentItemSelected(id: "0"))
        XCTAssertFalse(sut.isConsentItemSelected(id: "1"))
        
        XCTAssertEqual(notificationCount, 3)
    }
    
    func test_rejectAllConsentItemsPostsOnlyInfoConsentsAsGiven() throws {
        loadConsentSolution(consentSolution(consentItemConfigs: [(false, .setting), (false, .setting), (true, .info)]))
        
        sut.markConsentItem(id: "0", asSelected: true) // Mark some consent as selected to check if it is not posted
        
        sut.rejectAllConsentItems { _ in }
        
        let processingPurposes = try XCTUnwrap(mobileConsents.postedConsents?.processingPurposes)
        
        XCTAssertFalse(processingPurposes.first { $0.consentItemId == "0" }?.consentGiven ?? true)
        XCTAssertFalse(processingPurposes.first { $0.consentItemId == "1" }?.consentGiven ?? true)
        XCTAssertTrue(processingPurposes.first { $0.consentItemId == "2" }?.consentGiven ?? false)
    }
    
    private func loadConsentSolution(_ consentSolution: ConsentSolution) {
        mobileConsents.fetchConsentSolutionResult = .success(consentSolution)
        
        sut.loadConsentSolutionIfNeeded { _ in }
    }
}

private final class MobileConsentsMock: MobileConsentsProtocol {
    var fetchConsentSolutionResult: Result<ConsentSolution, Error>!
    var postConsentResult: Error?
    
    var postedConsents: Consent?
    
    func fetchConsentSolution(forUniversalConsentSolutionId universalConsentSolutionId: String, completion: @escaping (Result<ConsentSolution, Error>) -> Void) {
        completion(fetchConsentSolutionResult)
    }
    
    func postConsent(_ consent: Consent, completion: @escaping (Error?) -> Void) {
        postedConsents = consent
        completion(postConsentResult)
    }
}

struct DummyAsyncDispatcher: AsyncDispatcher {
    func async(execute work: @escaping () -> Void) {
        work()
    }
}

func consentSolution(consentItemConfigs: [(Bool, ConsentItemType)]) -> ConsentSolution {
    let consentItems = consentItemConfigs.enumerated().map { index, config in
        ConsentItem(
            id: "\(index)",
            required: config.0,
            type: config.1,
            translations: .init(translations: [], locale: nil)
        )
    }
    
    return ConsentSolution(
        id: "1",
        versionId: "1",
        title: .init(translations: [], locale: nil),
        description: .init(translations: [], locale: nil),
        templateTexts: .init(
            privacyCenterButton: .init(translations: [], locale: nil),
            rejectAllButton: .init(translations: [], locale: nil),
            acceptAllButton: .init(translations: [], locale: nil),
            acceptSelectedButton: .init(translations: [], locale: nil),
            savePreferencesButton: .init(translations: [], locale: nil),
            privacyCenterTitle: .init(translations: [], locale: nil),
            privacyPreferencesTabLabel: .init(translations: [], locale: nil),
            poweredByCoiLabel: .init(translations: [], locale: nil),
            consentPreferencesLabel: .init(translations: [], locale: nil)
        ),
        consentItems: consentItems
    )
}
