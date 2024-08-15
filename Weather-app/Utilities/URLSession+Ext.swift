//
//  URLSession+Ext.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import Foundation

protocol URLSessionAPI {
    func data(from url: URL) async throws -> (Data, URLResponse)
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionAPI {}
