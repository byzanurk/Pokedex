//
//  Endpoints.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

extension Endpoint {
    var baseURL: URL {
        return URL(string: "https://pokeapi.co")!
    }
    
    var headers: [String: String]? {
        [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
    
    var body: Data? { nil }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = normalizedPath(base: baseURL.path, path: path)
        components.queryItems = queryItems?.isEmpty == false ? queryItems : nil
        return components.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        request.httpBody = body
        return request
    }
    
    private func normalizedPath(base: String, path: String) -> String {
        let trimmedBase = base.hasSuffix("/") ? String(base.dropLast()) : base
        let trimmedPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        let combined = "\(trimmedBase)/\(trimmedPath)"
        if combined.hasPrefix("/api/v2") {
            return combined
        } else {
            return "/api/v2/\(trimmedPath)"
        }
    }
}
