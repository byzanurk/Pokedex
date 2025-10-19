//
//  FavouritesManager.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 19.10.2025.
//

import Foundation

final class FavouritesManager {
    private static let key = "favPokemonsIDs"
    
    static func getFavourites() -> [Int] {
        UserDefaults.standard.array(forKey: key) as? [Int] ?? []
     }
    
    static func add(_ id: Int) {
        var favourites = getFavourites()
        if !favourites.contains(id) {
            favourites.append(id)
            UserDefaults.standard.set(favourites, forKey: key)
        }
    }
    
    static func remove(_ id: Int) {
        var favourites = getFavourites()
        favourites.removeAll { $0 == id }
        UserDefaults.standard.set(favourites, forKey: key)
    }
    
    static func isFavourite(_ id: Int) -> Bool {
        getFavourites().contains(id)
    }
}
