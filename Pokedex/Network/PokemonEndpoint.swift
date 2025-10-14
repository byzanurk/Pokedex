// PokemonEndpoint.swift
// Pokedex

import Foundation

enum PokemonEndpoint: Endpoint {
    case list(limit: Int, offset: Int)
    case detail(id: Int)
    
    var path: String {
        switch self {
        case .list:
            return "/pokemon"
        case .detail(let id):
            return "/pokemon/\(id)"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .list(limit, offset):
            return [
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "offset", value: String(offset))
            ]
        case .detail:
            return nil
        }
    }
}
