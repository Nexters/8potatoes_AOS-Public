//
//  DivideLine.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/28/24.
//

import UIKit

import PinLayout
import Then

enum DivideType {
    case dot
    case line
}

class DivideLine: UIView {
    
    private let type: DivideType
    
    init(type: DivideType) {
        self.type = type
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = .bik5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if type == .line {
            lineView.pin
                .height(1)
                .horizontally()
        }
    }
    
    private func setup() {
        self.backgroundColor = .clear
        if type == .dot {
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.bik50.cgColor
            shapeLayer.lineWidth = 1
            shapeLayer.lineDashPattern = [2, 2] // 점선 패턴: [길이, 간격]
            shapeLayer.frame = self.bounds
            
            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: self.bounds.midY), CGPoint(x: self.bounds.width, y: self.bounds.midY)])
            shapeLayer.path = path
            
            self.layer.addSublayer(shapeLayer)
        } else {
            self.addSubview(lineView)
        }
    }
}
