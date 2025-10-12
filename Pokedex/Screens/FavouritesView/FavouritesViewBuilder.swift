//
//  FavouritesViewBuilder.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation
import UIKit

struct FavouritesViewBuilder {
    static func build(coordinator: CoordinatorProtocol) -> UIViewController {
        let service: NetworkRouterProtocol = NetworkRouter()
        let viewModel = FavouritesViewModel(service: service)
        let storyboard = UIStoryboard(name: "FavouritesView", bundle: nil)
        guard let favouritesVC = storyboard.instantiateViewController(withIdentifier: "FavouritesViewController") as? FavouritesViewController else { return UIViewController() }
        
        favouritesVC.viewModel = viewModel
        favouritesVC.coordinator = coordinator
        
        return favouritesVC

    }
}
