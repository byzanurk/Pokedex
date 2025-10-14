//
//  a.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 14.10.2025.
//

import Foundation
import UIKit

extension UIViewController {
    func navigate(to vc: UIViewController, coordinator: CoordinatorProtocol) {
        coordinator.eventOccurred(with: vc)
    }
}
