//
//  PokemonModel.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation

struct Pokemon: Decodable, Hashable {
    let id: Int
    let name: String
    let weight: Int
    let height: Int
    var isBookmarked: Bool = false
    let cries: Cries?
    let sprite: Sprite
    let abilities: [Ability]
    let moves: [Move]
    let types: [TypeElement]
    let stats: [Stat]

    private enum CodingKeys: String, CodingKey {
        case id, name, weight, height, cries, abilities, moves, types, stats
        case sprite = "sprites"
    }

    init(
        id: Int,
        name: String,
        weight: Int,
        height: Int,
        cries: Cries?,
        sprite: Sprite,
        abilities: [Ability],
        moves: [Move],
        types: [TypeElement],
        stats: [Stat],
        isBookmarked: Bool = false
    ) {
        self.id = id
        self.name = name
        self.weight = weight
        self.height = height
        self.cries = cries
        self.sprite = sprite
        self.abilities = abilities
        self.moves = moves
        self.types = types
        self.stats = stats
        self.isBookmarked = isBookmarked
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        weight = try container.decode(Int.self, forKey: .weight)
        height = try container.decode(Int.self, forKey: .height)
        cries = try? container.decode(Cries.self, forKey: .cries)
        sprite = try container.decode(Sprite.self, forKey: .sprite)
        abilities = try container.decode([Ability].self, forKey: .abilities)
        moves = try container.decodeLimited([Move].self, forKey: .moves, limit: 10)
        types = try container.decode([TypeElement].self, forKey: .types)
        stats = try container.decode([Stat].self, forKey: .stats)
        isBookmarked = false
    }

    var hp: Int {
        stats.first(where: { $0.stat.name.lowercased() == "hp" })?.baseStat ?? 0
    }
    var attack: Int {
        stats.first(where: { $0.stat.name.lowercased() == "attack" })?.baseStat ?? 0
    }
    var defense: Int {
        stats.first(where: { $0.stat.name.lowercased() == "defense" })?.baseStat ?? 0
    }
    var speed: Int {
        stats.first(where: { $0.stat.name.lowercased() == "speed" })?.baseStat ?? 0
    }
}

struct Sprite: Decodable, Hashable {
    let frontDefault: String?
    let backDefault: String?
}

struct Cries: Decodable, Hashable {
    let latest: String?
}

struct Ability: Decodable, Hashable {
    let ability: APIItem
}

struct Move: Decodable, Hashable {
    let move: APIItem
}

struct TypeElement: Decodable, Hashable {
    let type: APIItem
}

struct Stat: Decodable, Hashable {
    let baseStat: Int
    let stat: APIItem
    let effort: Int?

    private enum CodingKeys: String, CodingKey {
        case stat
        case baseStat = "base_stat"
        case effort
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        stat = try container.decode(APIItem.self, forKey: .stat)
        effort = try? container.decode(Int.self, forKey: .effort)
        baseStat = (try? container.decode(Int.self, forKey: .baseStat)) ?? 0
    }
}

// MARK: - Decoding helpers
private extension KeyedDecodingContainer {
    func decodeLimited<T: Decodable>(_ type: [T].Type, forKey key: K, limit: Int) throws -> [T] {
        var nested = try self.nestedUnkeyedContainer(forKey: key)
        var result: [T] = []
        result.reserveCapacity(min(limit, nested.count ?? limit))

        while !nested.isAtEnd && result.count < limit {
            let value = try nested.decode(T.self)
            result.append(value)
        }
        return result
    }
}
