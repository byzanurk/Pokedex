//
//  TabBarController.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import UIKit

class TabBarController: UITabBarController {
    
    private let coordinator: CoordinatorProtocol
    
    init(coordinator: CoordinatorProtocol) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        view.backgroundColor = .systemBackground
        
        let pokedexVC = PokedexViewBuilder.build(coordinator: coordinator)
        let itemsVC = ItemsViewBuilder.build(coordinator: coordinator)
        let favouritesVC = FavouritesViewBuilder.build(coordinator: coordinator)
        
        let pokedexNav = UINavigationController(rootViewController: pokedexVC)
        let itemsNav = UINavigationController(rootViewController: itemsVC)
        let favouritesNav = UINavigationController(rootViewController: favouritesVC)
        
        pokedexVC.tabBarItem = UITabBarItem(
            title: "Pokedex",
            image: UIImage(systemName: "square.grid.3x3"),
            selectedImage: UIImage(systemName: "square.grid.3x3.fill")
        )
        itemsVC.tabBarItem = UITabBarItem(
            title: "Items",
            image: UIImage(systemName: "xmark.triangle.circle.square"),
            selectedImage: UIImage(systemName: "xmark.triangle.circle.square.fill")
        )
        favouritesVC.tabBarItem = UITabBarItem(
            title: "Favourites",
            image: UIImage(systemName: "bookmark"),
            selectedImage: UIImage(systemName: "bookmark.fill")
        )
        
        [pokedexVC, itemsVC, favouritesVC].forEach {
            $0.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        
        tabBar.tintColor = .pokedexRed
        setViewControllers([pokedexNav, itemsNav, favouritesNav], animated: true)
        selectedIndex = 0
    }
    

}
