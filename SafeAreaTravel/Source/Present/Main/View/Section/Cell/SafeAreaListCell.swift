//
//  SafeAreaListCell.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/25/24.
//

import UIKit

import PinLayout
import FlexLayout
import Then

final class SafeAreaListCell: UICollectionViewCell {
    
    static let identifier = "SafeAreaListCell"
    
    private let safeAreaNameLabel = UILabel().then {
        $0.font = .suit(.Bold, size: 18)
        $0.textColor = .black
    }
    private let openInfoView  = TimeInfoView()
    private let oilPriceLabel = UILabel().then {
        $0.font = .suit(.SemiBold, size: 14)
        $0.textColor = .bik100
    }
    private let divideLabel = UILabel().then {
        $0.text = "|"
        $0.textColor = .bik30
        $0.font = .suit(.SemiBold, size: 14)
        $0.sizeToFit()
    }
    private let menuCountLabel = UILabel().then {
        $0.font = .suit(.SemiBold, size: 14)
        $0.sizeToFit()
    }
    private let priceInfoFlexContainer = UIView()

    private let directionInfoLabel = UILabel()
    private let starRateLabel = UILabel().then {
        $0.textColor = UIColor(hexString: "34C11D")
        $0.text = "네이버 평점 ★ "
        $0.font = .suit(.Bold, size: 12)
        $0.sizeToFit()
    }
    private let rateFelxContainer = UIView()
    
    func configureCell(oilInfo: String, rateInfo: String, menuCount: String, title: String, open: Bool) {
        safeAreaNameLabel.text  = title
        oilPriceLabel.text = oilInfo
        oilPriceLabel.setColorForText(textForAttribute: "휘발유", withColor: .bik40)
        oilPriceLabel.setColorForText(textForAttribute: "경유", withColor: .bik40)
        menuCountLabel.text = "메뉴 \(menuCount)가지"
    }
    
    private func layout() {
        self.backgroundColor = UIColor(hexString: "FFF1E7")
        [safeAreaNameLabel, openInfoView, rateFelxContainer, priceInfoFlexContainer].forEach {
            self.addSubview($0)
        }
        rateFelxContainer.flex
            .direction(.row)
            .alignItems(.stretch)
            .define {  flex in
                flex.addItem(directionInfoLabel)
                flex.addItem(starRateLabel)
                    .marginLeft(8)
            }
        priceInfoFlexContainer.flex
            .direction(.row)
            .alignItems(.stretch)
            .define {  define in
                flex.addItem(oilPriceLabel)
            }
        
        safeAreaNameLabel.pin
            .top(32)
            .left(20)
            .sizeToFit()
        
        openInfoView.pin
            .top(32)
            .left(20)

        rateFelxContainer.pin
            .below(of: safeAreaNameLabel)
            .marginTop(16)
        
        priceInfoFlexContainer.pin
            .below(of: rateFelxContainer)
            .horizontally(20)
            .marginTop(20)
            .marginBottom(32)
        
        
        
    }
    
    override func draw(_ rect: CGRect) {
         super.draw(rect)
         
         // 겹쳐지는 부분에 라인 그리기
         let linePath = UIBezierPath()
         linePath.move(to: CGPoint(x: 0, y: rect.height - 10))
         linePath.addLine(to: CGPoint(x: rect.width, y: rect.height - 10))
         linePath.lineWidth = 2.0

         UIColor.red.setStroke() // 라인 색상 설정
         linePath.stroke()
     }
    
    override func layoutSubviews() {
        layout()
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
