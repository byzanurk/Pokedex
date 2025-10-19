//
//  ItemsViewModel.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation

protocol ItemsViewModelProtocol {
    var delegate: ItemsViewModelDelegate? { get set }
    var categories: [APIItem] { get }
    func fetchCategories(limit: Int, offset: Int)
    func fetchCategories()
    func selectCategory(at index: Int)
    func fetchCategoryDetail(name: String, completion: @escaping (Result<ItemCategoryDetailResponse, NetworkError>) -> Void)
    func fetchItemDetail(name: String, completion: @escaping (Result<ItemDetail, NetworkError>) -> Void)
}

protocol ItemsViewModelDelegate: AnyObject {
    func didLoadCategories()
    func navigateToCategory(_ categoryName: String, title: String)
    func showError(message: String)
}

final class ItemsViewModel: ItemsViewModelProtocol {
    
    weak var delegate: ItemsViewModelDelegate?
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
    
    func selectCategory(at index: Int) {
        guard categories.indices.contains(index) else { return }
        let cat = categories[index]
        let title = cat.name.replacingOccurrences(of: "-", with: " ").capitalized
        delegate?.navigateToCategory(cat.name, title: title)
    }
    
    // MARK: - Forward item endpoints (ikon icin)
    func fetchCategoryDetail(name: String, completion: @escaping (Result<ItemCategoryDetailResponse, NetworkError>) -> Void) {
        service.fetchItemCategoryDetail(idOrName: name, completion: completion)
    }
    
    func fetchItemDetail(name: String, completion: @escaping (Result<ItemDetail, NetworkError>) -> Void) {
        service.fetchItemDetail(name: name, completion: completion)
    }
}
