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
    private var colorSet = UIColor.bik5
    
    private let lineView = UIView().then {
        $0.backgroundColor = .bik5
    }
    
    private let shapeLayer = CAShapeLayer()
    
    init(type: DivideType) {
        self.type = type
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if type == .line {
            lineView.pin
                .height(1)
                .horizontally()
            lineView.backgroundColor = colorSet
        } else if type == .dot {
            shapeLayer.frame = self.bounds
            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: self.bounds.midY), CGPoint(x: self.bounds.width, y: self.bounds.midY)])
            shapeLayer.path = path
        }
    }
    
    private func setup() {
        self.backgroundColor = .clear
        if type == .dot {
            shapeLayer.strokeColor = UIColor.bik5.cgColor
            shapeLayer.lineWidth = 2
            shapeLayer.lineDashPattern = [9, 9] // 점선 패턴: [길이, 간격]
            self.layer.addSublayer(shapeLayer)
        } else {
            self.addSubview(lineView)
        }
    }
    
    func updateColor(_ color: UIColor) {
        colorSet = color
        setNeedsLayout()
    }
}
