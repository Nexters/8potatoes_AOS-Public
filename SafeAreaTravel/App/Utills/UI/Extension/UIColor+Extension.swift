//
//  UIColor+Extension.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/25/24.
//

import UIKit

extension UIColor {
    
    // MARK: - Extension
    
    convenience init(hexString: String) {     /// Using hex
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }
    
    // MARK: - Color
    
    static let bg50 = UIColor(hexString: "FFFCF6") 
    static let bg100 = UIColor(hexString: "EAE0D6")
    static let bik100 = UIColor(hexString: "201404")
    static let bik70 = UIColor(hexString: "63594C")
    static let bik60 = UIColor(hexString: "797165")
    static let bik50 = UIColor(hexString: "90887D")
    static let bik40 = UIColor(hexString: "A69F95")
    static let bik30 = UIColor(hexString: "BFBFBE")
    static let bik20 = UIColor(hexString: "D2CEC6")
    static let bik5 = UIColor(hexString: "F4F0EA")
    static let bik10 = UIColor(hexString: "E9E5DE")
    
    static let main100 = UIColor(hexString: "FF7512")
    static let main30 = UIColor(hexString: "FFD6B8")
    static let main50 = UIColor(hexString: "FFBA89")
}
