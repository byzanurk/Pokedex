//
//  PokedexViewModel.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation

protocol PokedexViewModelProtocol {
    var pokemons: [Pokemon] { get set }
    var currentSortOption: SortOption { get }
    var delegate: PokedexViewModelOutput? { get set }
    func fetchPokemons()
    func sortPokemons(by option: SortOption)
}

protocol PokedexViewModelOutput: AnyObject {
    func showError(message: String)
    func didFetchPokemons()
}

final class PokedexViewModel: PokedexViewModelProtocol {

    var pokemons: [Pokemon] = []
    private(set) var currentSortOption: SortOption = .number
    weak var delegate: PokedexViewModelOutput?
    private let service: NetworkRouterProtocol
    private let pokemonsLock = NSLock()
    
    init(service: NetworkRouterProtocol) {
        self.service = service
    }
    
    func fetchPokemons() {
        service.fetchPokemonList(limit: 999, offset: 0) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let listResponse):
                print("Fetched list count:", listResponse.results.count)
                let group = DispatchGroup()
                var fetchedPokemons: [Pokemon] = []
                fetchedPokemons.reserveCapacity(listResponse.results.count)
                
                for item in listResponse.results {
                    guard let id = Self.extractID(from: item.url) else {
                        print("Could not extract ID from url: \(item.url)")
                        continue
                    }
                    
                    group.enter()
                    self.service.fetchPokemonDetail(id: id) { detailResult in
                        switch detailResult {
                        case .success(let pokemon):
                            print("Fetched pokemon:", pokemon.name)
                            self.pokemonsLock.lock()
                            fetchedPokemons.append(pokemon)
                            self.pokemonsLock.unlock()
                            group.leave()
                        case .failure(let error):
                            print("❌ fetchPokemonDetail failed for id \(id):", error)
                            group.leave()
                        }
                    }
                }
                
                group.notify(queue: .main) {
                    print("All fetches complete. Total fetched:", fetchedPokemons.count)
                    self.pokemons = fetchedPokemons
                    self.pokemons.sort(by: self.currentSortOption.sortDescriptor)
                    self.delegate?.didFetchPokemons()
                }
            case .failure(let error):
                print("❌ fetchPokemonList failed:", error)
                DispatchQueue.main.async {
                    self.delegate?.showError(message: error.localizedDescription)
                }
            }
        }
    }
    
    func sortPokemons(by option: SortOption) {
        DispatchQueue.main.async {
            self.currentSortOption = option
            self.pokemons.sort(by: option.sortDescriptor)
            self.delegate?.didFetchPokemons()
        }
    }
    
    // MARK: - Helpers
    private static func extractID(from urlString: String) -> Int? {
        // Örnek: https://pokeapi.co/api/v2/pokemon/1/
        let trimmed = urlString.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard let lastComponent = trimmed.split(separator: "/").last,
              let id = Int(lastComponent) else {
            return nil
        }
        return id
    }
}
