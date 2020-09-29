//
//  NetworkManager.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 24/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation

enum NetworkResponseError: LocalizedError {
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
    case noProperResponse
    
    var errorDescription: String? {
        switch self {
        case .authenticationError: return "You need to be authenticated first."
        case .badRequest: return "Bad request"
        case .outdated: return "The url you requested is outdated."
        case .failed: return "Network request failed."
        case .noData: return "Response returned with no data to decode."
        case .unableToDecode: return "We could not decode the response."
        case .noProperResponse: return "No proper response."
        }
    }
}

enum NetworkResult<T> {
    case success
    case failure(T)
}

class NetworkManager {
    static let environment: Environment = .staging
    private let provider = Provider<APIService>()
    
    private let baseURL: URL
    
    init(withBaseURL url: URL) {
        baseURL = url
    }
    
    func getConsents(forUUID uuid: String, completion: @escaping (ConsentSolution?, Error?) -> Void) {
        provider.request(.getConsents(uuid: uuid)) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                completion(nil, NetworkResponseError.noProperResponse)
                return
            }
            
            switch response.result {
            case .success:
                if let error = error {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    completion(nil, NetworkResponseError.noData)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let consentSolution = try decoder.decode(ConsentSolution.self, from: data)
                    completion(consentSolution, nil)
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func cancel() {
        provider.cancel()
    }
}

extension HTTPURLResponse {
    var result: NetworkResult<NetworkResponseError> {
        switch self.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(.authenticationError)
        case 501...599: return .failure(.badRequest)
        case 600: return .failure(.outdated)
        default: return .failure(.failed)
        }
    }
}
