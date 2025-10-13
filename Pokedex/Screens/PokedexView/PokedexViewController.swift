//
//  ViewController.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import UIKit

final class PokedexViewController: BaseViewController {
    
    var coordinator: CoordinatorProtocol!
    var viewModel: PokedexViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pokedex"
    }


}

