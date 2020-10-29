//
//  APIError.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 12/10/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation

struct APIError: LocalizedError, Decodable {
    let statusCode: Int
    let message: String
    let error: String
    
    var errorDescription: String? {
        "\(error): \(message)"
    }
}
