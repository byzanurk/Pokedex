//
//  PokemonModel.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import Foundation

struct Pokemon: Decodable {
    let id: Int
    let name: String
    let weight: Int?
    let height: Int?
    let cries: Cries?
    let sprite: Sprite
    let abilities: [Ability]?
    let moves: [Move]?
    let types: [Type]?
    let stats: [Stat]?

    var hp: Int {
        statValue(named: "hp")
    }
    var attack: Int {
        statValue(named: "attack")
    }
    var defense: Int {
        statValue(named: "defense")
    }
    var speed: Int {
        statValue(named: "speed")
    }

    private enum CodingKeys: String, CodingKey {
        case id, name, weight, height, cries, abilities, moves, types, stats
        case sprite = "sprites"
    }

    init(
        id: Int,
        name: String,
        weight: Int,
        height: Int,
        cries: Cries,
        sprite: Sprite,
        abilities: [Ability],
        moves: [Move],
        types: [Type],
        stats: [Stat]
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
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        weight = try? container.decode(Int.self, forKey: .weight)
        height = try? container.decode(Int.self, forKey: .height)
        cries = try? container.decode(Cries.self, forKey: .cries)

        sprite = (try? container.decode(Sprite.self, forKey: .sprite))
            ?? Sprite(frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/0.png",
                      backDefault: "")

        abilities = try? container.decode([Ability].self, forKey: .abilities)
        moves = try? container.decode([Move].self, forKey: .moves)
        types = try? container.decode([Type].self, forKey: .types)
        stats = try? container.decode([Stat].self, forKey: .stats)
    }

    private func statValue(named name: String) -> Int {
        let key = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return stats?.first {
            $0.stat.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == key
        }?.baseStat ?? 0
    }
}

// MARK: - Nested models
struct Ability: Decodable {
    let ability: APIItem
}

struct Sprite: Decodable {
    let frontDefault: String
    let backDefault: String
}

struct Move: Decodable {
    let move: APIItem
}

struct Cries: Decodable {
    let latest: String?
}

struct Type: Decodable {
    let type: APIItem
}

struct Stat: Decodable {
    let baseStat: Int
    let stat: APIItem

    private enum CodingKeys: String, CodingKey {
        case stat
        case baseStat = "base_stat"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        stat = try container.decode(APIItem.self, forKey: .stat)
        baseStat = try container.decodeIfPresent(Int.self, forKey: .baseStat) ?? 0
    }
}
