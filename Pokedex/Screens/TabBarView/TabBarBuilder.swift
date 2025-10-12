//
//  TabBarBuilder.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation
import UIKit

final class TabBarBuilder {
    static func build(coordinator: CoordinatorProtocol) -> UITabBarController {
        let tabBar = TabBarController(coordinator: coordinator)
        return tabBar
    }
 }
