//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 14.10.2025.
//

import Foundation

protocol PokemonDetailViewModelProtocol {
    var selectedPokemon: Pokemon? { get set }
    var pokemonID: Int? { get set }
    var delegate: PokemonDetailViewModelOutput? { get set }
    func fetchPokemonDetail()
}

protocol PokemonDetailViewModelOutput: AnyObject {
    func didLoadPokemon(_ pokemon: Pokemon)
    func showError(message: String)
}

final class PokemonDetailViewModel: PokemonDetailViewModelProtocol {
    
    var selectedPokemon: Pokemon?
    var pokemonID: Int?
    weak var delegate: PokemonDetailViewModelOutput?
    private let service: NetworkRouterProtocol
    
    init(service: NetworkRouterProtocol, pokemonID: Int? = nil, selectedPokemon: Pokemon? = nil) {
        self.service = service
        self.pokemonID = pokemonID
        self.selectedPokemon = selectedPokemon
    }
    
    func fetchPokemonDetail() {
        if let pokemon = selectedPokemon {
            delegate?.didLoadPokemon(pokemon)
            return
        }
        guard let id = pokemonID else {
            delegate?.showError(message: "Pokemon ID not set.")
            return
        }
        service.fetchPokemonDetail(id: id) { [weak self] result in
            switch result {
            case .success(let pokemon):
                self?.selectedPokemon = pokemon
                self?.delegate?.didLoadPokemon(pokemon)
            case .failure(let error):
                self?.delegate?.showError(message: error.localizedDescription)
            }
        }
    }
}
