//
//  APIService.swift
//  MobileConsents
//
//  Created by Jan Lipmann on 24/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation


enum APIService: EndPointType {
    
    case getConsents(uuid: String)
    case postConsent(uuid: String)
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://produrl.com"
        case .staging: return "https://stagingurl.com"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        return ""
    }
    
    var method: HTTPMethod {
        switch self {
        case .getConsents:
            return .get
        case .postConsent:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .postConsent(let uuid):
            return ["uuid" : uuid]
        default:
            return nil
        }
    }
    
    var task: Task {
        if let parameters = parameters {
            return .requestWithParameters(parameters: parameters, encoding: .jsonEncoding)
        }
        return .request
    }
    
    
}
