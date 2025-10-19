//
//  ItemCategoryDetailResponse.swift
//  Pokedex
//

import Foundation

struct ItemCategoryDetailResponse: Decodable {
    let id: Int
    let name: String
    let items: [APIItem]
}
