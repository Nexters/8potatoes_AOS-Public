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
    private var isLastCell: Bool = false

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
    private let priceInfoFlexContainer = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
    }

    private let directionInfoLabel = UILabel().then {
        $0.textColor = .bik60
        $0.text = "부산방면 | "
        $0.font = .suit(.Bold, size: 12)
        $0.sizeToFit()
    }
    private let starRateLabel = UILabel().then {
        $0.textColor = UIColor(hexString: "34C11D")
        $0.text = "네이버 평점 ★ "
        $0.font = .suit(.Bold, size: 12)
        $0.sizeToFit()
    }
    private let rateFelxContainer = UIView()
    
    func configureCell(oilInfo: String,
                       diselInfo: String,
                       rateInfo: String,
                       menuCount: String,
                       title: String,
                       direction: String,
                       open: Bool,
                       isLast: Bool) {
        safeAreaNameLabel.text  = title
        oilPriceLabel.text = "휘발유: \(oilInfo)  경유: \(diselInfo)"
        starRateLabel.text = "네이버 평점 ★ \(rateInfo)"
        oilPriceLabel.setColorForText(textForAttribute: "휘발유", withColor: .bik40)
        oilPriceLabel.setColorForText(textForAttribute: "경유", withColor: .bik40)
        menuCountLabel.text = "메뉴 \(menuCount)가지"
        menuCountLabel.setColorForText(textForAttribute: "메뉴", withColor: .bik40)
        directionInfoLabel.text = direction
        menuCountLabel.sizeToFit()
        oilPriceLabel.sizeToFit()
        starRateLabel.sizeToFit()
        isLastCell = isLast
        openInfoView.configre(open: open)
        setNeedsDisplay()
    }
    
    private func layout() {
        self.backgroundColor = UIColor(hexString: "FFF1E7")
        [safeAreaNameLabel, openInfoView, rateFelxContainer, priceInfoFlexContainer].forEach {
            self.contentView.addSubview($0)
        }

        rateFelxContainer.flex
            .direction(.row)
            .alignItems(.baseline)
            .define { flex in
                flex.addItem(directionInfoLabel)
                    .marginLeft(20)
                flex.addItem(starRateLabel)
                    .marginLeft(8)
            }

        priceInfoFlexContainer.flex
            .direction(.row)
            .alignItems(.center)
            .define { flex in
                flex.addItem(oilPriceLabel)
                    .marginLeft(20)
                flex.addItem(divideLabel)
                    .marginLeft(16)
                flex.addItem(menuCountLabel)
                    .marginLeft(16)
            }

        safeAreaNameLabel.pin
            .top(32)
            .left(20)
            .sizeToFit()

        openInfoView.pin
            .width(91)
            .height(31)
            .top(32)
            .right(20)

        rateFelxContainer.pin
            .below(of: safeAreaNameLabel)
            .height(12)
            .width(200)
            .marginTop(16)
            .marginLeft(20)


        priceInfoFlexContainer.pin
            .below(of: rateFelxContainer)
            .height(36)
            .marginTop(20)
            .horizontally(20)
    
        rateFelxContainer.flex.layout()
        priceInfoFlexContainer.flex.layout()

    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard !isLastCell else { return } /// 마지막 셀이면 선을 그리지 않음
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        
        /// 선 색깔
        context.setStrokeColor(UIColor.main30.cgColor)
        
        /// 선 굵기
        context.setLineWidth(4.0)

        /// 선의 패턴 : [점선의 크기, 사이간격]
        let dashPattern: [CGFloat] = [9, 9]
        context.setLineDash(phase: 0, lengths: dashPattern)
        
        /// 선그리기
        context.move(to: CGPoint(x: 0, y: rect.height))
        context.addLine(to: CGPoint(x: rect.width, y: rect.height))
        context.strokePath()
        
        context.restoreGState()
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()

        // 재사용될 때 이전 상태 초기화
        safeAreaNameLabel.text = ""
        oilPriceLabel.text = ""
        starRateLabel.text = ""
        menuCountLabel.text = ""
        openInfoView.configre(open: false)  // 기본값 설정
        isLastCell = true
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
