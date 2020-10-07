//
//  ConsentTests.swift
//  MobileConsentsSDKTests
//
//  Created by Jan Lipmann on 06/10/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import XCTest

final class ConsentTests: XCTestCase {
    func testJSONRepresentation() throws {
        let purpose = Purpose(consentItemId: "CONSENT_ITEM_ID", consentGiven: true, language: "PL")
        var consent = Consent(consentSolutionId: "ID", consentSolutionVersionId: "VERSION_ID", customData: ["FIRST_DATA_KEY": "FIRST_DATA"])
        consent.addProcessingPurpose(purpose)
        let json = consent.JSONRepresentation()
        
        XCTAssertEqual(json["universalConsentSolutionId"] as? String, consent.consentSolutionId, "Consent JSONRepresentation should return properly encoded object")
    }

    func testAddPurpose() throws {
        let purpose = Purpose(consentItemId: "CONSENT_ITEM_ID", consentGiven: true, language: "PL")
        var consent = Consent(consentSolutionId: "ID", consentSolutionVersionId: "VERSION_ID", customData: [:])
        consent.addProcessingPurpose(purpose)
        
        XCTAssertEqual(purpose.consentItemId, consent.processingPurposes.first?.consentItemId, "Add purpose to Consent - consentItemIds should be equal")
    }
    
    func testParsedCustomData() throws {
        let customData = ["FIRST_DATA_KEY": "FIRST_DATA"]
        let consent = Consent(consentSolutionId: "ID", consentSolutionVersionId: "VERSION_ID", customData: customData )
        let parsedCustomData = consent.parsedCustomData()
        
        XCTAssertEqual(parsedCustomData.first?["fieldName"], customData.first?.key, "")
        XCTAssertEqual(parsedCustomData.first?["fieldValue"], customData.first?.value, "")
    }
}
