//
//  PokedexViewModel.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation

protocol PokedexViewModelProtocol {
    var delegate: PokedexViewModelOutput? { get set }
}

protocol PokedexViewModelOutput: AnyObject {
    func showError(message: String)
}

final class PokedexViewModel: PokedexViewModelProtocol {
    
    weak var delegate: PokedexViewModelOutput?
    private let service: NetworkRouterProtocol
    
    init(service: NetworkRouterProtocol) {
        self.service = service
    }
    
}
