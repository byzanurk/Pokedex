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
    func didUpdateItems()
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
                    self.service.fetchItemDetail(
                        name: item.name
                            .lowercased()
                            .replacingOccurrences(of: " ", with: "-")
                    ) { result in
                        switch result {
                        case .success(let detail):
                            detailedItems.append(detail)
                            
                            if let effect = detail.effectEntries?.first(where: { $0.language.name.caseInsensitiveCompare("en") == .orderedSame })?.effect {
                                print("✅ \(detail.name ?? "-") -> effect: \(effect)")
                            } else {
                                print("⚠️ \(detail.name ?? "-") -> effect_entries missing or empty")
                            }
                            
                        case .failure(let error):
                            print("❌ Failed to fetch \(item.name): \(error.localizedDescription)")
                        }
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    self.items = detailedItems.sorted { ($0.name ?? "") < ($1.name ?? "") }
                    self.delegate?.didUpdateItems()
                }

            case .failure(let error):
                self.delegate?.showError(message: error.localizedDescription)
            }
        }
    }
}
