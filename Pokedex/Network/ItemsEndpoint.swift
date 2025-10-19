//
//  ItemsEndpoint.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 19.10.2025.
//

import Foundation

enum ItemsEndpoint: Endpoint {
    case categories(limit: Int, offset: Int)                 // /item-category
    case categoryDetail(idOrName: String)                    // /item-category/{id|name}
    case itemDetail(name: String)                            // /item/{name}

    var path: String {
        switch self {
        case .categories:
            return "/item-category"
        case .categoryDetail(let idOrName):
            return "/item-category/\(idOrName)"
        case .itemDetail(let name):
            return "/item/\(name)"
        }
    }

    var method: HTTPMethod { .get }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .categories(limit, offset):
            return [
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "offset", value: "\(offset)")
            ]
        case .categoryDetail, .itemDetail:
            return nil
        }
    }
}
