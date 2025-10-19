//
//  ItemDetailViewModel.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 19.10.2025.
//

import Foundation

protocol ItemDetailViewModelProtocol {
    var selectedCategoryItem: APIItem? { get set }
    var delegate: ItemDetailViewModelOutput? { get set }
}

protocol ItemDetailViewModelOutput: AnyObject {
    func showError(message: String)
}

final class ItemDetailViewModel: ItemDetailViewModelProtocol {
    
    var selectedCategoryItem: APIItem?
    
    weak var delegate: ItemDetailViewModelOutput?
    private let service: NetworkRouterProtocol
    
    init(service: NetworkRouterProtocol) {
        self.service = service
    }
    
}

