//
//  FavouritesViewModel.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation

protocol FavouritesViewModelProtocol {
    var delegate: FavouritesViewModelOutput? { get set }
}

protocol FavouritesViewModelOutput: AnyObject {
    func showError(message: String)
}

final class FavouritesViewModel: FavouritesViewModelProtocol {
    
    weak var delegate: FavouritesViewModelOutput?
    private let service: NetworkRouterProtocol
    
    init(service: NetworkRouterProtocol) {
        self.service = service
    }
    
    
}
