//
//  Environment.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 22/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

enum Environment {
    case staging
    case production
    
    var apiURLString: String {
        switch self {
        case .staging:
            return "staging_url"
        case .production:
            return "production_url"
        }
    }
}
