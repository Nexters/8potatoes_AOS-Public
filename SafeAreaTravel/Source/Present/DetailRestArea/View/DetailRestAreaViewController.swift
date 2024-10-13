//
//  DetailRestAreaViewController.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import UIKit

import PinLayout
import FlexLayout
import RxCocoa
import ReactorKit

final class DetailRestAreaViewController: BaseViewController, ReactorKit.View {
    
    // MARK: - Properties

    var disposeBag = DisposeBag()
    
    // MARK: - UI
    
    /// 상단 휴게소 정보 UI
    private let safeAreaNameLabel = UILabel()
    private let directionLabel = UILabel()
    private let safeAreaInfoLabel = UILabel()
    private let infoFlexContainer = UIView()
    
    private let scrollView = UIScrollView()
    private let infoSegment = HusikSegment(frame: .zero)
    
    /// 각각의 정보 뷰
    private let foodInfoView = FoodInfoView()
    private let oilInfoView = OilInfoView()
    private let etcInfoView = EtcInfoView()
    
    /// 컨테이너 뷰: 세그먼트에 따른 다른 뷰를 담을 컨테이너
    private let segmentContainerView = UIView()

    // MARK: - Init & LifeCycle
    
    
    // MARK: - SetUpUI
    
    override func configure() {
        setSegment()
    }
    
    override func addView() {
        self.view.addSubview(scrollView)
        [].forEach {
            scrollView.addSubview($0)
        }
    }
    
    override func layout() {
        scrollView.pin
            .all()
        
        infoFlexContainer.flex
            .direction(.column)
            .alignItems(.stretch)
            .define {
                $0.addItem()
                    .direction(.row)
                    .define { flex in
                    flex.addItem(safeAreaNameLabel)
                        .grow(1)
                    flex.addItem(directionLabel)
                        .grow(1)
                }
                    .alignSelf(.center)
                
                $0.addItem(safeAreaInfoLabel)
                    .marginTop(20)
                    .alignSelf(.center)
            }
        infoFlexContainer.flex.layout(mode: .fitContainer)
        
        infoSegment.pin
            .below(of: infoFlexContainer)
            .marginTop(40)
            .horizontally()
            .height(35)
        
        segmentContainerView.pin
            .below(of: infoSegment)
            .horizontally()
            .bottom()

    }
    
    private func setSegment() {
        let segmentTitles = ["먹거리", "주유·주차", "기타정보"]
        infoSegment.configureSegments(titles: segmentTitles)
    }

    
    // MARK: - Bind
    
     func bind(reactor: DetailRestAreaReactor) {
         reactor.action.onNext(.viewDidLoad)
         bindState(reactor: reactor)
         bindAction(reactor: reactor)
    }
    
    private func bindState(reactor: DetailRestAreaReactor) {
        reactor.state
            .compactMap{$0.info}
            .bind(onNext: {  [weak self] info in
                self?.directionLabel.text = info.direction
                self?.safeAreaNameLabel.text = info.name
                self?.safeAreaInfoLabel.text = info.safeAreaInfo
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAction(reactor: DetailRestAreaReactor) {
        
    }
}
