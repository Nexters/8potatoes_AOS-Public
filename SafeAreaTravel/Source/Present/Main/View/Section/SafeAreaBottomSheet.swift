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
        $0.text = "총 n개의 휴게소를 들릴 수 있어요."
        $0.textColor = .bik100
        $0.font = .suit(.Bold, size: 18)
        $0.sizeToFit()
    }
    private let desLabel =  UILabel().then {
        $0.text = "전국 휴게소의 주차 시설 및 화장실은 24시간 이용 가능합니다."
        $0.font = .suit(.Medium, size: 12)
        $0.sizeToFit()
        $0.textColor = UIColor(hexString: "A69F95")
    }
    private let safeAreaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 161)
        $0.minimumLineSpacing = 0 /// 줄 간격 설정
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
        [countLabel, desLabel, safeAreaCollectionView].forEach {
            self.view.addSubview($0)
        }
    }
    
    override func layout() {
        countLabel.pin
            .top(28)
            .hCenter()
        desLabel.pin
            .below(of: countLabel)
            .marginTop(24)
            .hCenter()
        safeAreaCollectionView.pin
            .below(of: desLabel)
            .marginTop(20)
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
        let items = [
            SafeAreaInfo(oilInfo: "1999원", rateInfo: "4.0", menuCount: "5", title: "홍길동 휴게소", isOpen: true),
            SafeAreaInfo(oilInfo: "2099원", rateInfo: "4.5", menuCount: "6", title: "이순신 휴게소", isOpen: false),
            SafeAreaInfo(oilInfo: "2099원", rateInfo: "4.5", menuCount: "6", title: "최지철 휴게소", isOpen: false),
            SafeAreaInfo(oilInfo: "1999원", rateInfo: "4.0", menuCount: "5", title: "강감찬 휴게소", isOpen: true),
        ]
        
        Observable.just(items)
        .bind(to: safeAreaCollectionView.rx.items(cellIdentifier: SafeAreaListCell.identifier, cellType: SafeAreaListCell.self)) { index, item, cell in
            cell.configureCell(oilInfo: item.oilInfo,
                               rateInfo: item.rateInfo,
                               menuCount: item.menuCount,
                               title: item.title,
                               open: item.isOpen,
                               isLast: index == items.count - 1)
        }
        .disposed(by: disposeBag)

    }
}
extension SafeAreaBottomSheet: UICollectionViewDelegate {
    
}
