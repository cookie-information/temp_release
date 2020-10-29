//
//  Date+Extensions.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 06/10/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation

extension Date {
    var iso8601withFractionalSeconds: String { return Formatter.iso8601withFractionalSeconds.string(from: self) }
}
