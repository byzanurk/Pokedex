//
//  NetworkManager.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation

protocol NetworkManagerProtocol {
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
    
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let request = endpoint.urlRequest else {
            DispatchQueue.main.async { completion(.failure(.invalidURL)) }
            return
        }
        
        let task = session.dataTask(with: request) { [decoder] data, response, error in
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
//                // Debug: API'den gelen ham JSON'u konsola bastır
//                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
//                    print("Pokemon Detay JSON:", json)
//                }
                let decoded = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                // Ayrıntılı hata logu
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .typeMismatch(let type, let context):
                        print("Decoding typeMismatch: \(type), context: \(context.debugDescription), codingPath: \(context.codingPath)")
                    case .valueNotFound(let type, let context):
                        print("Decoding valueNotFound: \(type), context: \(context.debugDescription), codingPath: \(context.codingPath)")
                    case .keyNotFound(let key, let context):
                        print("Decoding keyNotFound: \(key), context: \(context.debugDescription), codingPath: \(context.codingPath)")
                    case .dataCorrupted(let context):
                        print("Decoding dataCorrupted: \(context.debugDescription), codingPath: \(context.codingPath)")
                    @unknown default:
                        print("Decoding unknown error: \(decodingError)")
                    }
                } else {
                    print("Decoding error: \(error)")
                }
                DispatchQueue.main.async { completion(.failure(.decodingError)) }
            }
        }
        task.resume()
    }
}
