//
//  AsyncDispatcher.swift
//  MobileConsentsSDK
//
//  Created by Sebastian Osiński on 24/02/2021.
//  Copyright © 2021 ClearCode. All rights reserved.
//

import Foundation

protocol AsyncDispatcher {
    func async(execute work: @escaping () -> Void)
}

extension DispatchQueue: AsyncDispatcher {
    func async(execute work: @escaping () -> Void) {
        async(group: nil, qos: .unspecified, flags: [], execute: work)
    }
}
