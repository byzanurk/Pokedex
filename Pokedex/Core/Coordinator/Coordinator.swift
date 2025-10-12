//
//  Coordinator.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation
import UIKit

final class Coordinator: CoordinatorProtocol {
    
    private(set) var tabBarController: UITabBarController?
    weak var parentCoordinator: CoordinatorProtocol?
    
    func eventOccurred(with viewController: UIViewController) {
        guard
            let tabBar = tabBarController,
                let nav = (tabBar.selectedViewController as? UINavigationController)
        else { return }
        nav.pushViewController(viewController, animated: true)
    }
    
    @discardableResult
    func start() -> UITabBarController {
        let tabBar = TabBarBuilder.build(coordinator: self)
        self.tabBarController = tabBar
        return tabBar
    }
}
