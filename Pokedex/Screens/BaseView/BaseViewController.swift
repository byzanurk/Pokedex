//
//  BaseViewController.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 13.10.2025.
//

import UIKit

class BaseViewController: UIViewController {

    var pageTitle: String = "" {
        didSet {
            self.navigationItem.title = pageTitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        tabBarItem.title = nil
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = false
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .pokedexRed
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.pixel17
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.pixel17
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.tintColor = .white
    }


    
}

