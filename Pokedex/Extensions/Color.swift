//
//  Color.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 12.10.2025.
//

import UIKit

extension UIColor {
    static let darkGrey = UIColor(hex: "222222")
    static let pokedexRed = UIColor(hex: "d53b47")
    static let orange = UIColor(hex: "f89e2e")
    static let blue = UIColor(hex: "3898fe")
    static let grey = UIColor(hex: "8db6d2")
    static let green = UIColor(hex: "5ba74f")
    
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.hasPrefix("#") ? String(hexString.dropFirst()) : hexString
        
        guard let hexNumber = UInt64(hexString, radix: 16), hexString.count == 6 else { return nil }
        
        let r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
        let g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
        let b = CGFloat(hexNumber & 0x0000FF) / 255
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

extension UIColor {
    var isLight: Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let brightness = (red * 299 + green * 587 + blue * 114) / 1000
            return brightness > 0.7
        }
        return false
    }
}
