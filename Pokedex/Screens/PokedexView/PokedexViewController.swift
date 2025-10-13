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
        setupNavButtons()
    }

    private func setupNavButtons() {
            
        // square.grid.3x3.fill
        // square.grid.4x3.fill
        let sortButton = UIBarButtonItem(
            image: UIImage(systemName: "square.grid.4x3.fill"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        
        // line.3.horizontal.decrease
        let gridButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease"),
            style: .plain,
            target: self,
            action: #selector(gridButtonTapped)
        )
        
        sortButton.tintColor = .white
        gridButton.tintColor = .white
        
        navigationItem.rightBarButtonItems = [gridButton, sortButton]
        
    }
    
    @objc private func sortButtonTapped() {
        // for now
        print("sort button tapped")
    }
    
    @objc private func gridButtonTapped() {
        // for now
        print("grid button tapped")
    }



}

