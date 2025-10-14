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
    
    init(service: NetworkRouterProtocol) {
        self.service = service
    }
    
    func fetchPokemons() {
        service.fetchPokemonList(limit: 1000, offset: 0) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let success):
                self.pokemons = success.results.enumerated().map { index, item in
                    let id = Int(item.url.split(separator: "/").last ?? "0") ?? (index + 1)
                    let imageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
                    
                    return Pokemon(
                        id: id,
                        name: item.name.capitalized,
                        weight: 0,
                        height: 0,
                        cries: Cries(latest: nil),
                        sprite: Sprite(frontDefault: imageURL, backDefault: nil),
                        abilities: [],
                        moves: [],
                        types: [],
                        stats: []
                    )
                }
                self.delegate?.didFetchPokemons()
            case .failure(let error):
                self.delegate?.showError(message: error.localizedDescription)
            }
        }
    }
    
    func sortPokemons(by option: SortOption) {
        currentSortOption = option
        pokemons.sort(by: option.sortDescriptor)
        delegate?.didFetchPokemons()
    }
    
    
}
