//
//  ItemModel.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 19.10.2025.
//

import Foundation

// MARK: - ItemDetail
class ItemDetail: Decodable {
    let id: Int
    let name: String
    let sprites: ItemSprite
    let category: APIItem
    let effect: [Effect]
    
    private enum CodingKeys: String, CodingKey {
        case id, name, sprites, category
        case effect = "effect_entries"
    }
    
    init(id: Int, name: String, sprites: ItemSprite, category: APIItem, effect: [Effect]) {
        self.id = id
        self.name = name
        self.sprites = sprites
        self.category = category
        self.effect = effect
    }
}

// MARK: - ItemData
struct ItemData {
    let title: String
    let items: [ItemDetail]
    
    var icon: String? {
        items.first?.sprites.default
    }
}

// MARK: - ItemSprite
struct ItemSprite: Decodable {
    let `default`: String
    
    private enum CodingKeys: String, CodingKey {
        case `default` = "default"
    }
}

// MARK: - Effect
struct Effect: Decodable {
    let effect: String
}

// MARK: - Mock Item
extension ItemDetail {
    static var common: ItemDetail {
        ItemDetail(
            id: 0,
            name: "Item",
            sprites: ItemSprite(default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/honey.png"),
            category: APIItem(name: "category", url: ""),
            effect: [
                Effect(effect: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
            ]
        )
    }
}
