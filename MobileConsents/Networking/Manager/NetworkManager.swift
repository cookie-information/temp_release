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
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .authenticationError: return "You need to be authenticated first."
        case .badRequest: return "Bad request"
        case .outdated: return "The url you requested is outdated."
        case .failed: return "Network request failed."
        case .noData: return "Response returned with no data to decode."
        case .unableToDecode: return "We could not decode the response."
        case .noProperResponse: return "No proper response."
        case .notFound: return "Not found"
        }
    }
}

enum NetworkResult<T> {
    case success
    case failure(T)
}

final class NetworkManager {
    static let environment: Environment = .staging
    private let provider = Provider<APIService>()
    private let baseURL: URL
    private let localStorageManager: LocalStorageManagerProtocol
    private let platformInformationGenerator: PlatformInformationGeneratorProtocol

    init(withBaseURL url: URL, localStorageManager: LocalStorageManagerProtocol = LocalStorageManager(), platformInformationGenerator: PlatformInformationGeneratorProtocol = PlatformInformationGenerator()) {
        self.baseURL = url
        self.localStorageManager = localStorageManager
        self.platformInformationGenerator = platformInformationGenerator
    }
    
    func getConsentSolution(forUUID uuid: String, completion: @escaping (Result<ConsentSolution, Error>) -> Void) {
        provider.request(.getConsents(uuid: uuid)) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(NetworkResponseError.noProperResponse))
            }

            switch response.result {
            case .success:
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    do {
                        let consentSolution = try JSONDecoder().decode(ConsentSolution.self, from: data)
                        completion(.success(consentSolution))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NetworkResponseError.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postConsent(_ consent: Consent, completion: @escaping (Error?) -> Void) {
        let platformInformation = platformInformationGenerator.generatePlatformInformation()
        let consentPayload = consent.JSONRepresentation()
        let userId = localStorageManager.userId
        provider.request(.postConsent(baseURL: baseURL, userId: userId, payload: consentPayload, platformInformation: platformInformation)) { _, response, error in
            if let error = error {
                completion(error)
            } else {
                guard let response = response as? HTTPURLResponse else {
                    return completion(NetworkResponseError.noProperResponse)
                }
                
                switch response.result {
                case .success: completion(nil)
                case .failure(let error): completion(error)
                }
            }
        }
    }
    
    func cancel() {
        provider.cancel()
    }
}
