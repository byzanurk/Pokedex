//
//  ItemDetailViewModel.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 19.10.2025.
//

import Foundation
import UIKit

protocol ItemDetailViewModelProtocol {
    var items: [ItemDetail] { get set }
    var selectedCategoryItem: APIItem? { get set }
    var delegate: ItemDetailViewModelOutput? { get set }
    func fetchItems()
}

protocol ItemDetailViewModelOutput: AnyObject {
    func showError(message: String)
}

final class ItemDetailViewModel: ItemDetailViewModelProtocol {
    
    var items: [ItemDetail] = []
    var selectedCategoryItem: APIItem?
    weak var delegate: ItemDetailViewModelOutput?
    private let service: NetworkRouterProtocol
    
    init(service: NetworkRouterProtocol) {
        self.service = service
    }
    
    func fetchItems() {
        guard let categoryName = selectedCategoryItem?.name else { return }

        service.fetchItemCategoryDetail(idOrName: categoryName) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let response):
                let apiItems = response.items
                var detailedItems: [ItemDetail] = []
                let group = DispatchGroup()

                for item in apiItems {
                    group.enter()
                    self.service.fetchItemDetail(name: item.name) { result in
                        switch result {
                        case .success(let detail):
                            detailedItems.append(detail)
                        case .failure:
                            break
                        }
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    self.items = detailedItems
                    (self.delegate as? ItemDetailViewController)?.tableView.reloadData()
                }

            case .failure(let error):
                self.delegate?.showError(message: error.localizedDescription)
            }
        }
    }
    
    
}

