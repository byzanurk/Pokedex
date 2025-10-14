//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 14.10.2025.
//

import Foundation

protocol PokemonDetailViewModelProtocol {
    var delegate: PokemonDetailViewModelOutput? { get set }
}

protocol PokemonDetailViewModelOutput: AnyObject {
    func showError(message: String)
}

final class PokemonDetailViewModel: PokemonDetailViewModelProtocol {
    
    weak var delegate: PokemonDetailViewModelOutput?
    private let service: NetworkRouterProtocol
    
    init(service: NetworkRouterProtocol) {
        self.service = service
    }
    
    
}
