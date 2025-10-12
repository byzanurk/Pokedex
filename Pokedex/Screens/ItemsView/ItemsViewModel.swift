//
//  ItemsViewModel.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation

protocol ItemsViewModelProtocol {
    var delegate: ItemsViewModelDelegate? { get set }
}

protocol ItemsViewModelDelegate: AnyObject {
    func showError(message: String)
}

final class ItemsViewModel: ItemsViewModelProtocol {
    
    weak var delegate: ItemsViewModelDelegate?
    private let service: NetworkRouterProtocol
    
    init(service: NetworkRouterProtocol) {
        self.service = service
    }
    
    
}
