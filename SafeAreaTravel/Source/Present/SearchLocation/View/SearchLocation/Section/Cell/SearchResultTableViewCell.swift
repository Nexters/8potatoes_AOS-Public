//
//  SearchResultTableViewCell.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/28/24.
//

import UIKit

import Then
import PinLayout
import FlexLayout

final class SearchResultTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultTableViewCell"
    
    private let locationImg = UIImageView().then {
        $0.image = UIImage(named: "location")
    }
    private let locationLabel = UILabel().then {
        $0.font = .suit(.Bold, size: 16)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    private let loadAddressDesView = RoundView().then {
        $0.configre(backgroundColor: .clear, title: "도로명", titleColor: .bik60)
    }
    private let numAddressDesView = RoundView().then {
        $0.configre(backgroundColor: .clear, title: "지번", titleColor: .bik60)
    }
    private let loadAddressLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .suit(.Medium, size: 14)
        $0.lineBreakMode = .byWordWrapping
        $0.textColor = .bik60
        $0.sizeToFit()
    }
    private let numAddressLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .bik60
        $0.font = .suit(.Medium, size: 14)
        $0.lineBreakMode = .byWordWrapping
        $0.sizeToFit()
    }
    
    private let locationFlexContainer = UIView()
    private let loadAddrexFlexContainer = UIView()
    private let numAddressFlexContainer = UIView()
    private let rootflexContainer = UIView()
    
    func configure(_ model: SearchLocationModel) {
        locationLabel.text = model.name
        loadAddressLabel.text = model.fullAddressRoad
        numAddressLabel.text = model.fullAddressNum
        setNeedsLayout()
        layoutIfNeeded()  
    }
    
    private func layout() {
        self.addSubview(rootflexContainer)
        
        locationFlexContainer.flex
            .direction(.row)
            .alignItems(.start)
            .define {  flex in
                flex.addItem(locationImg)
                    .width(24)
                    .height(24)
                flex.addItem(locationLabel)
                    .marginLeft(8)
                    .grow(1)
            }
        
        loadAddrexFlexContainer.flex
            .direction(.row)
            .alignItems(.start)
            .define {  flex in
                flex.addItem(loadAddressDesView)
                    .height(26)
                    .width(loadAddressDesView.frame.width)
                flex.addItem(loadAddressLabel)
                    .marginLeft(12)
                    .marginTop(4)
                    .grow(1)
            }
        numAddressFlexContainer.flex
            .direction(.row)
            .alignItems(.start)
            .define {  flex in
                flex.addItem(numAddressDesView)
                    .height(26)
                    .width(numAddressDesView.frame.width)
                flex.addItem(numAddressLabel)
                    .marginLeft(12)
                    .marginTop(4)
                    .grow(1)
            }
        
        rootflexContainer.flex
            .direction(.column)
            .alignItems(.stretch)
            .define {  flex in
                flex.addItem(locationFlexContainer)
                    .marginTop(20)
                    .marginLeft(20)
                flex.addItem(loadAddrexFlexContainer)
                    .marginTop(12)
                    .marginLeft(20)
                flex.addItem(numAddressFlexContainer)
                    .marginTop(4)
                    .marginLeft(20)
            }
        
        rootflexContainer.pin.all()
        rootflexContainer.flex.layout()
    }
    
    override func layoutSubviews() {
        selectionStyle = .default 
        layout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        locationLabel.text = nil
        loadAddressLabel.text = nil
        numAddressLabel.text = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: SearchResultTableViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
extension SearchResultTableViewCell {
    private func getHighlightedText(fullText: String, highlight: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: highlight, options: .caseInsensitive)
        if range.location != NSNotFound {
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        }
        return attributedString
    }
}
