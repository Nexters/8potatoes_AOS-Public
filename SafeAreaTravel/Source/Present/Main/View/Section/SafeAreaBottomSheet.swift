//
//  SafeAreaBottomSheet.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/23/24.
//

import UIKit

import RxSwift
import RxCocoa

final class SafeAreaBottomSheet: BaseViewController {
    // MARK: - Properties
    
    
    // MARK: - UI
    
    private let countLabel = UILabel().then {
        $0.text = "n개의"
        $0.sizeToFit()
    }
    private let safeAreaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = UIColor(hexString: "F4F7F8")
    }
    
    override func addView() {
        [countLabel, safeAreaCollectionView].forEach {
            self.view.addSubview($0)
        }
    }
    
    override func layout() {
        countLabel.pin
            .top(28)
            .hCenter()
        safeAreaCollectionView.pin
            .below(of: countLabel)
            .marginTop(25)
            .horizontally()
            .bottom()
    }
    
    override func configure() {
        self.view.layer.cornerRadius = 20
        self.view.backgroundColor = .white
        self.isModalInPresentation = true
    }
    
}
