//
//  ISO8601DateFormatter+Extensions.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 06/10/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone? = TimeZone(secondsFromGMT: 0)) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}
