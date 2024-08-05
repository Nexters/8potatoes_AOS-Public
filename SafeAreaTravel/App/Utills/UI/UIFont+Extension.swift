//
//  UIFont+Extension.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 8/1/24.
//

import UIKit

extension UIFont {
    public enum SUIT: String {
        case Bold = "Bold"
        case Medium = "Medium"
        case Regular = "Regular"
        case ExtraBold = "ExtraBold"
        case Heavy = "Heavy"
        case Light = "Light"
        case Thin = "Thin"
        case SemiBold = "SemiBold"
    }
    static func suit(_ type: SUIT, size: CGFloat) -> UIFont {
        return UIFont(name: "SUIT-\(type.rawValue)", size: size) ?? .systemFont(ofSize: size)
    }
}
