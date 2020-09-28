//
//  NetworkManager.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 24/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation

struct NetworkManager {
    static let environment: Environment = .staging
    let provider = Provider<APIService>()
    
    func getConsents(forUUID uuid: String, completion: @escaping ([ConsentItem], Error?) -> Void) {
        provider.request(.getConsents(uuid: uuid)) { data, response, error in
            // TODO: to be implemented
        }
    }
}
