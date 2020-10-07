//
//  Formatter+Extensions.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 06/10/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}
