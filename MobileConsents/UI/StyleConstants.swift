//
//  StyleConstants.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 22/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

enum StyleConstants {
    private static let fontSize = { UIFontMetrics(forTextStyle: .body).scaledValue(for: 13) }

    static let textViewStyle: [String: [String: HTMLTextView.StyleValue]] = [
        "body": [
            "font-family": "-apple-system;",
            "font-size": .init { "\(fontSize())px" },
            "color": .init { UIColor.consentText.hexString }
        ],
        "a": [
            "font-weight": "bold",
            "text-decoration": "none",
            "color": .init { UIColor.link.hexString }
        ],
        "li": [
            "list-style-position": "inside"
        ]
    ]
}
