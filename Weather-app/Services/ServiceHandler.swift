//
//  ServiceHandler.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import Foundation

protocol ServiceHandling {
    func makeServiceCall<T: Decodable>(for request: URLRequest, type: T.Type) async throws -> (T, URLResponse)
}

class ServiceHandler: ServiceHandling {
    enum ServiceHandlingError: Error {
        case responseError(ServiceError)
    }
    
    private var session: URLSessionAPI

    init(session: URLSessionAPI) {
        self.session = session
    }

    func makeServiceCall<T: Decodable>(for request: URLRequest, type: T.Type) async throws -> (T, URLResponse) {
        print(request.url ?? "")
        let (data, response) = try await session.data(for: request)
        if let error = try? JSONDecoder().decode(ServiceError.self, from: data) {
            throw ServiceHandlingError.responseError(error)
        }

        let responseObject = try JSONDecoder().decode(type.self, from: data)
        print(responseObject)
        return (responseObject, response)
    }
}
