//
//  APIModel.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 19.10.2025.
//

import Foundation

struct PokemonListResponse: Decodable {
    let count: Int
    let results: [APIItem]
}

struct APIItem: Decodable {
    let name: String
    let url: String
}

// PokeAPI'nin çoğu liste cevabı bu yapıda gelir
struct NamedAPIResourceList: Decodable {
    let count: Int
    let results: [APIItem]
}
