//
//  FavouritesViewModel.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation

protocol FavouritesViewModelProtocol {
    var pokemons: [Pokemon] { get set }
    var delegate: FavouritesViewModelOutput? { get set }
    func loadFavourites()
}

protocol FavouritesViewModelOutput: AnyObject {
    func showError(message: String)
    func didFetchFavourites()
}

final class FavouritesViewModel: FavouritesViewModelProtocol {
    
    var pokemons: [Pokemon] = []
    weak var delegate: FavouritesViewModelOutput?
    private let service: NetworkRouterProtocol
    
    init(service: NetworkRouterProtocol) {
        self.service = service
    }
    
    func loadFavourites() {
        let favouritesIDs = FavouritesManager.getFavourites()
        guard !favouritesIDs.isEmpty else {
            pokemons = []
            delegate?.didFetchFavourites()
            return
        }
        
        let group = DispatchGroup()
        var fetched: [Pokemon] = []
        
        for id in favouritesIDs {
            group.enter()
            service.fetchPokemonDetail(id: id) { result in
                switch result {
                case .success(let pokemon):
                    fetched.append(pokemon)
                case .failure(let error):
                    print("Failed to fetch favourite id \(id): \(error.localizedDescription)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.pokemons = fetched
            self.delegate?.didFetchFavourites()
        }
    }
}
