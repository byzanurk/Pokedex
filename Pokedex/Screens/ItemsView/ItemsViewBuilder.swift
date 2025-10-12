//
//  ItemsViewBuilder.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation
import UIKit

struct ItemsViewBuilder {
    static func build(coordinator: CoordinatorProtocol) -> UIViewController {
        let service: NetworkRouterProtocol = NetworkRouter()
        let viewModel = ItemsViewModel(service: service)
        let storyboard = UIStoryboard(name: "ItemsView", bundle: nil)
        guard let itemsVC = storyboard.instantiateViewController(withIdentifier: "ItemsViewController") as? ItemsViewController else { return UIViewController() }
        
        itemsVC.viewModel = viewModel
        itemsVC.coordinator = coordinator
        
        return itemsVC
    }
}
