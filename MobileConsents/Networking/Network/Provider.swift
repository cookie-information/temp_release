//
//  Provider.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 24/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation

public typealias NetworkProviderCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

protocol NetworkProvider: AnyObject {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkProviderCompletion)
    func cancel()
}

private enum NetworkConstants {
    static let timeoutInterval: Double = 10.0
}

final class Provider<EndPoint: EndPointType>: NetworkProvider {
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkProviderCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            NetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
            task?.resume()
        } catch {
            completion(nil, nil, error)
        }
    }
    
    func cancel() {
        task?.cancel()
    }
    
    private func buildRequest(from endpoint: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: endpoint.baseURL.appendingPathComponent(endpoint.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: NetworkConstants.timeoutInterval)
        
        request.httpMethod = endpoint.method.rawValue
        switch endpoint.task {
        case .request:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .requestWithParameters(let parameters, let encoding):
            try self.configureParameters(
                bodyParameters: parameters,
                bodyEncoding: encoding,
                urlParameters: nil,
                request: &request
            )
        }
        return request
    }
    
    private func configureParameters(bodyParameters: Parameters?, bodyEncoding: ParameterEncoding, urlParameters: Parameters?, request: inout URLRequest) throws {
        try bodyEncoding.encode(
            urlRequest: &request,
            bodyParameters: bodyParameters,
            urlParameters: urlParameters
        )
    }
}
