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
    
    private let locationLabel = UILabel()
    private let loadAddressDesView = RoundView().then {
        $0.configre(backgroundColor: .clear, title: "도로명", titleColor: .bik50)
    }
    private let numAddressDesView = RoundView().then {
        $0.configre(backgroundColor: .clear, title: "지번", titleColor: .bik50)
    }
    private let loadAddressLabel = UILabel()
    private let numAddressLabel = UILabel()
    
    private let loadAddrexFlexContainer = UIView()
    private let numAddressFlexContainer = UIView()
    private let rootflexContainer = UIView()
    
    func configure(_ model: SearchLocationModel) {
        locationLabel.text = model.name
        loadAddressLabel.text = model.fullAddressRoad
        numAddressLabel.text = model.fullAddressNum
    }
    
    private func layout() {
        self.addSubview(rootflexContainer)
        
        loadAddrexFlexContainer.flex
            .direction(.row)
            .alignItems(.start)
            .define {  flex in
                flex.addItem(loadAddressDesView)
                    .height(53)
                flex.addItem(loadAddressLabel)
                    .marginLeft(12)
            }
        numAddressFlexContainer.flex
            .direction(.row)
            .alignItems(.start)
            .define {  flex in
                flex.addItem(numAddressDesView)
                    .height(53)
                flex.addItem(numAddressLabel)
                    .marginLeft(12)
            }
        
        rootflexContainer.flex
            .direction(.column)
            .alignItems(.stretch)
            .define {  flex in
                flex.addItem(locationLabel)
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
        layout()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
