//
//  SortOption.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 14.10.2025.
//

import UIKit

enum SortOption: String, CaseIterable {
    case number = "Number"
    case name = "Name"
    case height = "Height"
    case weight = "Weight"
    case hp = "Hp"
    case attack = "Attack"
    case defense = "Defense"
    case speed = "Speed"
    
    var iconName: String {
        switch self {
        case .number: return "number"
        case .name: return "textformat"
        case .height: return "arrow.up.and.down"
        case .weight: return "scalemass.fill"
        case .hp: return "heart.fill"
        case .attack: return "bolt.fill"
        case .defense: return "shield.fill"
        case .speed: return "gauge.with.dots.needle.67percent"
        }
    }
    
    var sortDescriptor: (Pokemon, Pokemon) -> Bool {
        switch self {
        case .number:
            return { $0.id < $1.id }
        case .name:
            return { $0.name.lowercased() < $1.name.lowercased() }
        case .height:
            return { $0.height < $1.height }
        case .weight:
            return { $0.weight < $1.weight }
        case .hp:
            return {
                let hp1 = $0.stats.first { $0.stat.name == "hp" }?.baseStat ?? 0
                let hp2 = $1.stats.first { $0.stat.name == "hp" }?.baseStat ?? 0
                return hp1 < hp2
            }
        case .attack:
            return {
                let attack1 = $0.stats.first { $0.stat.name == "attack" }?.baseStat ?? 0
                let attack2 = $1.stats.first { $0.stat.name == "attack" }?.baseStat ?? 0
                return attack1 < attack2
            }
        case .defense:
            return {
                let defense1 = $0.stats.first { $0.stat.name == "defense" }?.baseStat ?? 0
                let defense2 = $1.stats.first { $0.stat.name == "defense" }?.baseStat ?? 0
                return defense1 < defense2
            }
        case .speed:
            return {
                let speed1 = $0.stats.first { $0.stat.name == "speed" }?.baseStat ?? 0
                let speed2 = $1.stats.first { $0.stat.name == "speed" }?.baseStat ?? 0
                return speed1 < speed2
            }
        }
    }
}
