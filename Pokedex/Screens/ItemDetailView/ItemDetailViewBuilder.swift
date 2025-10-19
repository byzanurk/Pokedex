//
//  ItemDetailViewBuilder.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 19.10.2025.
//

import Foundation
import UIKit

struct ItemDetailViewBuilder {
    static func build(coordinator: CoordinatorProtocol, selectedCategory: APIItem) -> UIViewController {
        let service: NetworkRouterProtocol = NetworkRouter()
        let viewModel = ItemDetailViewModel(service: service)
        viewModel.selectedCategoryItem = selectedCategory
        
        let storyboard = UIStoryboard(name: "ItemDetailView", bundle: nil)
        guard let itemDetailVC = storyboard.instantiateViewController(withIdentifier: "ItemDetailView") as? ItemDetailViewController else { return UIViewController() }
        
        itemDetailVC.viewModel = viewModel
        itemDetailVC.coordinator = coordinator
        
        let formattedTitle = selectedCategory.name.replacingOccurrences(of: "-", with: " ").capitalized
        itemDetailVC.title = formattedTitle
        
        return itemDetailVC
    }
}

