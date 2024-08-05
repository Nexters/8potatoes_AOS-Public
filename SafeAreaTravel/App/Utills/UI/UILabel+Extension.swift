//
//  UILabel+Extension.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/28/24.
//

import UIKit

extension UILabel {
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let attributedText = NSMutableAttributedString(string: self.text ?? "")
        let range = (self.text! as NSString).range(of: textForAttribute)
        attributedText.addAttribute(.foregroundColor, value: color, range: range)
        self.attributedText = attributedText
    }
}
