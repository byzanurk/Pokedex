//
//  PokedexViewBuilder.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation
import UIKit

struct PokedexViewBuilder {
    static func build(coordinator: CoordinatorProtocol) -> UIViewController {
        let service: NetworkRouterProtocol = NetworkRouter()
        let viewModel = PokedexViewModel(service: service)
        let storyboard = UIStoryboard(name: "PokedexView", bundle: nil)
        guard let pokedexVC = storyboard.instantiateViewController(withIdentifier: "PokedexViewController") as? PokedexViewController else { return UIViewController() }
        
        pokedexVC.viewModel = viewModel
        pokedexVC.coordinator = coordinator
        
        return pokedexVC
    }
}
