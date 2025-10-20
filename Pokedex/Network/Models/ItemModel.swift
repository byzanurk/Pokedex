//
//  ItemModel.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 19.10.2025.
//

import Foundation

// MARK: - ItemDetail
struct ItemDetail: Decodable {
    let id: Int?
    let name: String?
    let sprites: ItemSprite?
    let category: APIItem?
    let effectEntries: [ItemEffectEntry]?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, sprites, category
        case effectEntries = "effect_entries"
    }
    
    var englishEffect: String? {
        effectEntries?.first {
            $0.language.name.caseInsensitiveCompare("en") == .orderedSame
        }?.effect
    }
}

// MARK: - ItemData
struct ItemData {
    let title: String
    let items: [ItemDetail]
    
    var icon: String? {
        items.first?.sprites?.defaultURL
    }
}

// MARK: - ItemSprite
struct ItemSprite: Decodable {
    let defaultURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case defaultURL = "default"
    }
}

// MARK: - ItemEffectEntry
struct ItemEffectEntry: Decodable {
    let effect: String?
    let shortEffect: String?
    let language: APIItem
    
    private enum CodingKeys: String, CodingKey {
        case effect
        case shortEffect = "short_effect"
        case language
    }
}

// MARK: - Mock Item
extension ItemDetail {
    static var common: ItemDetail {
        ItemDetail(
            id: 0,
            name: "item",
            sprites: ItemSprite(defaultURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/honey.png"),
            category: APIItem(name: "category", url: ""),
            effectEntries: [
                ItemEffectEntry(effect: "Lorem ipsum dolor sit amet...", shortEffect: "Lorem ipsum", language: APIItem(name: "en", url: ""))
            ]
        )
    }
}
