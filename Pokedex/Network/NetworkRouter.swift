//
//  NetworkRouter.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation

protocol NetworkRouterProtocol {
    func fetchPokemonList(limit: Int, offset: Int, completion: @escaping (Result<PokemonListResponse, NetworkError>) -> Void)
}

final class NetworkRouter: NetworkRouterProtocol {
    
    private let service: NetworkManagerProtocol
    
    init(service: NetworkManagerProtocol = NetworkManager()) {
        self.service = service
    }
    
    func fetchPokemonList(limit: Int, offset: Int, completion: @escaping (Result<PokemonListResponse, NetworkError>) -> Void) {
        let endpoint = PokemonEndpoint.list(limit: limit, offset: offset)

        service.request(endpoint, completion: completion)
    }
}

