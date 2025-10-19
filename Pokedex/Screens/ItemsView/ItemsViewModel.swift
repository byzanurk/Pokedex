//
//  ItemsViewModel.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation

protocol ItemsViewModelProtocol {
    var delegate: ItemsViewModelOutput? { get set }
    var categories: [APIItem] { get }
    func fetchCategories(limit: Int, offset: Int)
    func fetchCategories()
    func fetchCategoryDetail(name: String, completion: @escaping (Result<ItemCategoryDetailResponse, NetworkError>) -> Void)
    func fetchItemDetail(name: String, completion: @escaping (Result<ItemDetail, NetworkError>) -> Void)
}

protocol ItemsViewModelOutput: AnyObject {
    func didLoadCategories()
    func showError(message: String)
}

final class ItemsViewModel: ItemsViewModelProtocol {
    
    weak var delegate: ItemsViewModelOutput?
    private let service: NetworkRouterProtocol
    
    private(set) var categories: [APIItem] = []
    
    init(service: NetworkRouterProtocol) {
        self.service = service
    }
    
    func fetchCategories(limit: Int, offset: Int) {
        service.fetchItemCategories(limit: limit, offset: offset) { [weak self] (result: Result<NamedAPIResourceList, NetworkError>) in
            guard let self else { return }
            switch result {
            case .success(let list):
                self.categories = list.results.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
                self.delegate?.didLoadCategories()
            case .failure(let error):
                self.delegate?.showError(message: error.localizedDescription)
            }
        }
    }
    
    func fetchCategories() {
        fetchCategories(limit: 100, offset: 0)
    }
        
    // MARK: - Forward item endpoints (ikon icin)
    func fetchCategoryDetail(name: String, completion: @escaping (Result<ItemCategoryDetailResponse, NetworkError>) -> Void) {
        service.fetchItemCategoryDetail(idOrName: name, completion: completion)
    }
    
    func fetchItemDetail(name: String, completion: @escaping (Result<ItemDetail, NetworkError>) -> Void) {
        service.fetchItemDetail(name: name, completion: completion)
    }
}
