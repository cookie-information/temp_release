//
//  String+Extensions.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 06/10/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation

extension String {
    var iso8601withFractionalSeconds: Date? { return Formatter.iso8601withFractionalSeconds.date(from: self) }
}

extension String {
    var localized: String {
        NSLocalizedString(self, bundle: Bundle(for: BundleLocator.self), comment: "")
    }
}

private final class BundleLocator {}
