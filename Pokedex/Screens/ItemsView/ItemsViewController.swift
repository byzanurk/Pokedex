//
//  ItemsViewController.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import UIKit

final class ItemsViewController: BaseViewController {

    var coordinator: CoordinatorProtocol!
    var viewModel: ItemsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Items"

    }

}
