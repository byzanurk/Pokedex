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
            return { ($0.height ?? Int.min) < ($1.height ?? Int.min) }
        case .weight:
            return { ($0.weight ?? Int.min) < ($1.weight ?? Int.min) }
        case .hp:
            return { $0.hp > $1.hp }
        case .attack:
            return { $0.attack > $1.attack }
        case .defense:
            return { $0.defense > $1.defense }
        case .speed:
            return { $0.speed > $1.speed }
        }
    }
}
