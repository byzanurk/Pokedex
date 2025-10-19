//
//  NetworkRouter.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation

protocol NetworkRouterProtocol {
    // Pokemon
    func fetchPokemonList(limit: Int, offset: Int, completion: @escaping (Result<PokemonListResponse, NetworkError>) -> Void)
    func fetchPokemonDetail(id: Int, completion: @escaping (Result<Pokemon, NetworkError>) -> Void)

    // Items
    func fetchItemCategories(limit: Int, offset: Int, completion: @escaping (Result<NamedAPIResourceList, NetworkError>) -> Void)
    func fetchItemCategoryDetail(idOrName: String, completion: @escaping (Result<ItemCategoryDetailResponse, NetworkError>) -> Void)
    func fetchItemDetail(name: String, completion: @escaping (Result<ItemDetail, NetworkError>) -> Void)
}

final class NetworkRouter: NetworkRouterProtocol {
    
    private let service: NetworkManagerProtocol
    
    init(service: NetworkManagerProtocol = NetworkManager()) {
        self.service = service
    }
    
    // MARK: - Pokemon
    func fetchPokemonList(limit: Int, offset: Int, completion: @escaping (Result<PokemonListResponse, NetworkError>) -> Void) {
        let endpoint = PokemonEndpoint.list(limit: limit, offset: offset)
        service.request(endpoint, completion: completion)
    }
    
    func fetchPokemonDetail(id: Int, completion: @escaping (Result<Pokemon, NetworkError>) -> Void) {
        let endpoint = PokemonEndpoint.detail(id: id)
        service.request(endpoint, completion: completion)
    }
    
    // MARK: - Items
    func fetchItemCategories(limit: Int, offset: Int, completion: @escaping (Result<NamedAPIResourceList, NetworkError>) -> Void) {
        let endpoint = ItemsEndpoint.categories(limit: limit, offset: offset)
        service.request(endpoint, completion: completion)
    }
    
    func fetchItemCategoryDetail(idOrName: String, completion: @escaping (Result<ItemCategoryDetailResponse, NetworkError>) -> Void) {
        let endpoint = ItemsEndpoint.categoryDetail(idOrName: idOrName)
        service.request(endpoint, completion: completion)
    }
    
    func fetchItemDetail(name: String, completion: @escaping (Result<ItemDetail, NetworkError>) -> Void) {
        let endpoint = ItemsEndpoint.itemDetail(name: name)
        service.request(endpoint, completion: completion)
    }
}
