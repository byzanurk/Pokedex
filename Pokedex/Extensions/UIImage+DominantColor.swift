//
//  UIImage+DominantColor.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 13.10.2025.
//

import UIKit

extension UIImage {
    var dominantColor: UIColor? {
        guard let cgImage = self.cgImage else { return nil }
        
        let size = CGSize(width: 10, height: 10) // daha güvenilir örnek
        let bitmapData = calloc(Int(size.width*size.height*4), MemoryLayout<UInt8>.size)
        defer { free(bitmapData) }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: bitmapData,
                                      width: Int(size.width),
                                      height: Int(size.height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: Int(size.width)*4,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else { return nil }
        
        context.draw(cgImage, in: CGRect(origin: .zero, size: size))
        guard let data = context.data else { return nil }
        
        let ptr = data.bindMemory(to: UInt8.self, capacity: Int(size.width*size.height*4))
        var rTotal = 0, gTotal = 0, bTotal = 0, count = 0
        
        for i in stride(from: 0, to: Int(size.width*size.height*4), by: 4) {
            let alpha = ptr[i+3]
            if alpha > 0 {
                let r = Double(ptr[i])
                let g = Double(ptr[i+1])
                let b = Double(ptr[i+2])
                let brightness = (0.299 * r + 0.587 * g + 0.114 * b)
                if brightness > 40 { // çok koyu pikselleri dışla
                    rTotal += Int(pow(r / 255.0, 2.2) * 255)
                    gTotal += Int(pow(g / 255.0, 2.2) * 255)
                    bTotal += Int(pow(b / 255.0, 2.2) * 255)
                    count += 1
                }
            }
        }
        if count == 0 { return nil }

        let r = pow(CGFloat(rTotal) / CGFloat(count) / 255.0, 1/2.2)
        let g = pow(CGFloat(gTotal) / CGFloat(count) / 255.0, 1/2.2)
        let b = pow(CGFloat(bTotal) / CGFloat(count) / 255.0, 1/2.2)

        var color = UIColor(red: r, green: g, blue: b, alpha: 1)

        // Doygunluğu biraz artır
        var h: CGFloat = 0, s: CGFloat = 0, br: CGFloat = 0, a: CGFloat = 0
        if color.getHue(&h, saturation: &s, brightness: &br, alpha: &a) {
            color = UIColor(hue: h, saturation: min(s * 1.3, 1.0), brightness: br, alpha: a)
        }
        return color
    }
}
