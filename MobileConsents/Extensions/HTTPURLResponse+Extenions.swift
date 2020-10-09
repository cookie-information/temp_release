//
//  HTTPURLResponse+Extenions.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 29/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    var result: NetworkResult<NetworkResponseError> {
        switch self.statusCode {
        case 200...299: return .success
        case 404: return .failure(.notFound)
        case 401...500: return .failure(.authenticationError)
        case 501...599: return .failure(.badRequest)
        case 600: return .failure(.outdated)
        default: return .failure(.failed)
        }
    }
}
