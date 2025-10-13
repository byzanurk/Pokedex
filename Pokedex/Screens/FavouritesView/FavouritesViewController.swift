//
//  FavouritesViewController.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import UIKit

final class FavouritesViewController: BaseViewController {
    
    var coordinator: CoordinatorProtocol!
    var viewModel: FavouritesViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourites"

    }

}
