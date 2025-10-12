//
//  NetworkManager.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation

protocol NetworkManagerProtocol {
//    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
//    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
//        guard let request = endpoint.urlRequest else {
//            throw NetworkError.invalidURL
//        }
//        
//        let (data, response) = try await session.data(for: request)
//        
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw NetworkError.invalidResponse
//        }
//        
//        guard (200...299).contains(httpResponse.statusCode) else {
//            throw NetworkError.serverError(httpResponse.statusCode)
//        }
//        
//        do {
//            return try decoder.decode(T.self, from: data)
//        } catch {
//            throw NetworkError.decodingError
//        }
//    }
    
    // Completion tabanlı overload
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let request = endpoint.urlRequest else {
            DispatchQueue.main.async { completion(.failure(.invalidURL)) }
            return
        }
        
        let task = session.dataTask(with: request) { [decoder] data, response, error in
            // Hataları map et
            if let _ = error {
                DispatchQueue.main.async { completion(.failure(.invalidResponse)) }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async { completion(.failure(.invalidResponse)) }
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async { completion(.failure(.serverError(httpResponse.statusCode))) }
                return
            }
            guard let data else {
                DispatchQueue.main.async { completion(.failure(.invalidResponse)) }
                return
            }
            do {
                let decoded = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(.decodingError)) }
            }
        }
        task.resume()
    }
}
