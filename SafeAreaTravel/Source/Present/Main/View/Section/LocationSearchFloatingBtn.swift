//
//  LocationSearchFloatingBtn.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/23/24.
//

import UIKit

import PinLayout
import FlexLayout
import RxSwift
import Then

final class LocationSearchFloatingBtn: UIView {
    
    private let startBtn = UIButton().then {
        $0.setTitle("어디서 출발하세요?", for: .normal)
        $0.backgroundColor = .clear
        $0.setTitleColor(.bik30, for: .normal)
        $0.sizeToFit()
    }
    private let goalBtn = UIButton().then {
        $0.setTitle("어디까지 가세요?", for: .normal)
        $0.backgroundColor = .clear
        $0.setTitleColor(.bik30, for: .normal)
        $0.sizeToFit()
    }
    private let divideImg = UIImageView().then {
        $0.image = UIImage(systemName: "arrow.right")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .bik30
    }
    private let rootFlexContainer = UIView()

    private func layout() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex
            .direction(.row)
            .alignItems(.center)
            .define { flex in
            flex.addItem(startBtn)
                .marginLeft(16)
            flex.addItem(divideImg)
                .size(CGSize(width: 24, height: 24))
                .marginHorizontal(16)
            flex.addItem(goalBtn)
                .marginRight(16)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.layer.cornerRadius = 18
        self.applyShadow(color: UIColor(hexString: "000000"),
                         alpha: 0.2,
                         x: 0,
                         y: 10,
                         blur: 20,
                         spread: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
