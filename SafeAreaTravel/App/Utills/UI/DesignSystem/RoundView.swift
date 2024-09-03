//
//  RoundView.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/28/24.
//

import UIKit

import PinLayout

final class RoundView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .suit(.Medium, size: 14)
        $0.textColor = .bik60
    }
    
    func configre(backgroundColor: UIColor, title: String, titleColor: UIColor) {
        titleLabel.text = title
        titleLabel.sizeToFit()
        titleLabel.textColor = titleColor
        self.backgroundColor = backgroundColor
    }
    
    override func layoutSubviews() {
        self.pin
            .height(26)
            .width(titleLabel.frame.width + 20)
        
        titleLabel.pin
            .center()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.bik50.cgColor
        self.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
