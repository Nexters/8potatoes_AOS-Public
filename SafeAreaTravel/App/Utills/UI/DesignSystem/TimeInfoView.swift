//
//  TimeInfoView.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 8/3/24.
//

import UIKit

import PinLayout
import FlexLayout
import Then

final class TimeInfoView: UIView {
    
    private let infoLabel = UILabel().then {
        $0.font = .suit(.Bold, size: 12)
        $0.textColor = .bik70
    }
    private let forkImg = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }
    private let flexContainer = UIView()
    
    private func layout() {
        self.addSubview(flexContainer)
        flexContainer.flex
            .direction(.row)
            .alignContent(.center)
            .define {  flex in
                flex.addItem(forkImg)
                    .height(12)
                    .width(12)
                flex.addItem(infoLabel)
                    .marginLeft(1.5)
            }
        flexContainer.pin
            .vCenter()
            .hCenter()
        flexContainer.flex.layout()
    }
    
    convenience init(open: Bool) {
        self.init(frame: .zero)
        infoLabel.text = open ? "영업중" : "영업종료"
        infoLabel.sizeToFit()
        forkImg.image = open ? UIImage(named: "openFork") : UIImage(named: "closeFork")
    }
    
    override func layoutSubviews() {
        layout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
