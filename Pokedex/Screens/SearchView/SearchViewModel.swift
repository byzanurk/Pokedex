//
//  SearchViewModel.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 13.10.2025.
//

import Foundation

protocol SearchViewModelProtocol {
    var pokemons: [Pokemon] { get set }     // filtrelenmis liste
    var allPokemons: [Pokemon] { get set }  // temel liste
    var delegate: SearchViewModelOutput? { get set }
    func fetchAllPokemons()
}

protocol SearchViewModelOutput: AnyObject {
    func showError(message: String)
    func reloadCollectionView()
}

final class SearchViewModel: SearchViewModelProtocol {
    
    var pokemons: [Pokemon] = []
    var allPokemons: [Pokemon] = []
    weak var delegate: SearchViewModelOutput?
    private let service: NetworkRouterProtocol
    private let pokemonsLock = NSLock()
    
    init(service: NetworkRouterProtocol) {
        self.service = service
    }
    
    func fetchAllPokemons() {
        service.fetchPokemonList(limit: 999, offset: 0) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let listResponse):
                let group = DispatchGroup()
                var fetched: [Pokemon] = []
                fetched.reserveCapacity(listResponse.results.count)
                
                for item in listResponse.results {
                    guard let id = Self.extractID(from: item.url) else {
                        continue
                    }
                    group.enter()
                    self.service.fetchPokemonDetail(id: id) { detailResult in
                        switch detailResult {
                        case .success(let pokemon):
                            self.pokemonsLock.lock()
                            fetched.append(pokemon)
                            self.pokemonsLock.unlock()
                        case .failure(let error):
                            print("fetchPokemonDetail failed for id \(id): \(error)")
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    self.allPokemons = fetched
                    self.delegate?.reloadCollectionView()
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.showError(message: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Helpers
    private static func extractID(from urlString: String) -> Int? {
        // Örn: https://pokeapi.co/api/v2/pokemon/1/
        let trimmed = urlString.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard let last = trimmed.split(separator: "/").last,
              let id = Int(last) else {
            return nil
        }
        return id
    }
}

