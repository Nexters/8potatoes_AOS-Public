//
//  DivideLine.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/28/24.
//

import UIKit

import PinLayout

class DivideLine: UIView {
    
    private let lineView = UIView().then {
        $0.backgroundColor = .bik5
    }
    
    override func layoutSubviews() {
        lineView.pin
            .height(1)
            .horizontally()
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.addSubview(lineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
