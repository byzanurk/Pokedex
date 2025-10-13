//
//  SearchViewController.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 13.10.2025.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    var coordinator: CoordinatorProtocol!
    var viewModel: SearchViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        
    }

}
