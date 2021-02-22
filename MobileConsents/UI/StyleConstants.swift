//
//  StyleConstants.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 22/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import UIKit

enum StyleConstants {
    private static let bodyColor = UIColor.adaptive(light: .privacyCenterText, dark: .white)
    private static let fontSize = { UIFontMetrics(forTextStyle: .body).scaledValue(for: 13) }

    static let textViewStyle: [String: [String: HTMLTextView.StyleValue]] = [
        "body": [
            "font-family": "Rubik",
            "font-size": .init { "\(fontSize())px" },
            "color": .init { bodyColor.hexString }
        ],
        "a": [
            "font-weight": "bold",
            "text-decoration": "none",
            "color": .init { bodyColor.hexString }
        ],
        "li": [
            "list-style-position": "inside"
        ]
    ]
}
