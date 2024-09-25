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
    private let safeAreaList = BehaviorSubject<SafeAreaListInfo>(value: SafeAreaListInfo(totalReststopCount: 0, reststops: [])) // 초기값 설정
    let selectedCellRelay = PublishRelay<String>()
    
    // MARK: - UI
    
    private let countLabel = UILabel().then {
        $0.text = "총 000개의 휴게소를 들릴 수 있어요."
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
    
    init(info: SafeAreaListInfo) {
        super.init(nibName: nil, bundle: nil)
        safeAreaList.onNext(info)  // 데이터를 subject에 전달
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
        safeAreaList
            .bind(onNext: { [weak self] info in
                self?.countLabel.text = "총 \(info.totalReststopCount)개의 휴게소를 들릴 수 있어요."
            })
            .disposed(by: disposeBag)
           let reststopsObservable = safeAreaList
               .map { $0.reststops }

            reststopsObservable
               .bind(to: safeAreaCollectionView.rx.items(cellIdentifier: SafeAreaListCell.identifier, cellType: SafeAreaListCell.self)) { [weak self] index, item, cell in
                   guard let self = self else { return }
                   
                   let oilInfo = "\(item.gasolinePrice ?? "정보없음")"
                   let diselInfo = "\(item.dieselPrice ?? "정보없음")"
                   let rateInfo = "\(item.naverRating)"
                   let menuCount = "\(item.foodMenusCount)"
                   let title = item.name
                   let open = item.isOperating
                   let isLast = index == (try! self.safeAreaList.value().reststops.count) - 1  // 마지막 셀인지 확인

                   cell.configureCell(
                    oilInfo: oilInfo,
                    diselInfo: diselInfo,
                       rateInfo: rateInfo,
                       menuCount: menuCount,
                       title: title,
                       open: open,
                       isLast: isLast
                   )
               }
               .disposed(by: disposeBag)
        
        safeAreaCollectionView.rx
            .modelSelected(SafeAreaListInfo.SafeAreaInfo.self)
            .subscribe(onNext: { [weak self] selectedItem in
                self?.selectedCellRelay.accept(selectedItem.code)
            })
            .disposed(by: disposeBag)
       }

}
extension SafeAreaBottomSheet: UICollectionViewDelegate {
    
}
