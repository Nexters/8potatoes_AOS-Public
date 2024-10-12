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
        $0.text = "식당 영업중"
    }
    private let forkImg = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
    }
    private let flexContainer = UIView()
    
    private func layout() {
        flexContainer.pin
            .all()
        flexContainer.flex.layout(mode: .adjustHeight)
    }
    
    func configre(open: Bool) {
        forkImg.image = open ? UIImage(named: "openFork") : UIImage(named: "closeFork")
        infoLabel.text = open ? "식당 영업중" : "식당 영업끝"
        infoLabel.textColor = open ? .white : .bik70
        self.backgroundColor = open ? .main100 : .bik10
        self.layer.cornerRadius = 8
    }
    
    override func layoutSubviews() {
        layout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(flexContainer)
        flexContainer.flex
            .direction(.row)
            .alignContent(.center)
            .define {  flex in
                flex.addItem(forkImg)
                    .marginTop(8)
                    .marginLeft(8)
                    .height(16)
                    .width(16)
                flex.addItem(infoLabel)
                    .marginTop(8)
                    .marginLeft(4)
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
