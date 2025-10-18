//
//  PokemonDetailViewBuilder.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 14.10.2025.
//

import Foundation
import UIKit

struct PokemonDetailViewBuilder {
    static func build(coordinator: CoordinatorProtocol, selectedPokemon: Pokemon) -> UIViewController {
        let service: NetworkRouterProtocol = NetworkRouter()
        let viewModel = PokemonDetailViewModel(service: service, selectedPokemon: selectedPokemon)
        let storyboard = UIStoryboard(name: "PokemonDetailView", bundle: nil)
        guard let pokemonDetailVC = storyboard.instantiateViewController(withIdentifier: "PokemonDetailView") as? PokemonDetailViewController else { return UIViewController() }
        
        pokemonDetailVC.viewModel = viewModel
        pokemonDetailVC.coordinator = coordinator
        pokemonDetailVC.selectedPokemon = selectedPokemon
        
        return pokemonDetailVC
    }
    
    static func build(coordinator: CoordinatorProtocol, pokemonID: Int) -> UIViewController {
        let service: NetworkRouterProtocol = NetworkRouter()
        let viewModel = PokemonDetailViewModel(service: service, pokemonID: pokemonID)
        let storyboard = UIStoryboard(name: "PokemonDetailView", bundle: nil)
        guard let pokemonDetailVC = storyboard.instantiateViewController(withIdentifier: "PokemonDetailView") as? PokemonDetailViewController else { return UIViewController() }
        
        pokemonDetailVC.viewModel = viewModel
        pokemonDetailVC.coordinator = coordinator
        
        return pokemonDetailVC
    }
}

