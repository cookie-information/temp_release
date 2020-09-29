//
//  APIService.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 24/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation

enum APIService: EndPointType {
    case getConsents(uuid: String)
    case postConsent(baseURL: URL, uuid: String)
    
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .production: return "https://produrl.com"
        case .staging: return "https://cdnapi-staging.azureedge.net/v1/"
        }
    }
    
    var baseURL: URL? {
        switch self {
        case .getConsents:
            return URL(string: environmentBaseURL)
        case .postConsent(let baseURL, _):
            return baseURL
        } 
    }
    
    var path: String {
        switch self {
        case .getConsents(let uuid):
            return "\(uuid)/consent-data.json"
        case .postConsent:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getConsents: return .get
        case .postConsent: return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .postConsent(_, let uuid): return ["uuid": uuid]
        default: return nil
        }
    }
    
    var task: Task {
        guard let parameters = parameters else { return .request }

        return .requestWithParameters(parameters: parameters, encoding: .jsonEncoding)
    }
    
    var sampleData: Data {
        // TODO: will be refactored for unit testing purposes
        switch self {
        case .getConsents(let uuid):
            return uuid.data(using: .utf8) ?? Data()
        case .postConsent(let baseURL, let uuid):
            return uuid.data(using: .utf8) ?? Data()
        }
    }
}
