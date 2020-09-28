//
//  EndpointType.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 23/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: Task { get }
}
