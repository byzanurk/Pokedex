//
//  APIModel.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation

struct PokemonListResponse: Codable {
    let results: [APIItem]
}

struct APIItem: Codable, Hashable {
    let name: String
    let url: String
}

