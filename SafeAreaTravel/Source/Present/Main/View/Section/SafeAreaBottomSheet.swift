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
    
    private var disposeBag = DisposeBag()
    
    // MARK: - UI
    
    private let countLabel = UILabel().then {
        $0.text = "n개의"
        $0.textColor = .bik100
        $0.sizeToFit()
    }
    private let safeAreaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 161)
        $0.minimumLineSpacing = 0 // 줄 간격 설정
        $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }).then {
        $0.backgroundColor = .clear
        $0.register(SafeAreaListCell.self, forCellWithReuseIdentifier: SafeAreaListCell.identifier)
    }

    // MARK: - Init & LifeCycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupUI

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
        safeAreaCollectionView.delegate = self
        bindUI()
    }
    
    // MARK: - bind

    private func bindUI() {
        Observable.just([1,2,3,4,5,6])
            .bind(to: safeAreaCollectionView.rx.items(cellIdentifier: SafeAreaListCell.identifier, cellType: SafeAreaListCell.self))
        {  index, cell, item in

        }
        .disposed(by: disposeBag)
    }
}
extension SafeAreaBottomSheet: UICollectionViewDelegate {
    
}
