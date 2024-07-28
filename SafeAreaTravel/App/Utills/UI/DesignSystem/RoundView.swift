//
//  RoundView.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/28/24.
//

import UIKit

import PinLayout

final class RoundView: UIView {
    
    private let titleLabel = UILabel()
    
    func configre(backgroundColor: UIColor, title: String, titleColor: UIColor) {
        titleLabel.text = title
        titleLabel.sizeToFit()
        titleLabel.textColor = titleColor
        self.backgroundColor = backgroundColor
    }
    
    override func layoutSubviews() {
        titleLabel.pin
            .top(8)
            .left(8)
            .sizeToFit()
        
        self.pin
            .width(titleLabel.frame.width + 16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
