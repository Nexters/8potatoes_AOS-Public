//
//  StartViewController.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import UIKit

import Then
import PinLayout
import FlexLayout

final class StartViewController: BaseViewController {
    // MARK: - Properties

    private let reactor: StartReactor

    // MARK: - UI
    
    private let scrollView = UIScrollView()
    private let welecomeLabel = UILabel().then {
        $0.text = "쥬쥬와 함께\n휴게소 맛집을 찾아보세요!"
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    private let welecomeImg = UIImageView().then {
        $0.image = UIImage(named: "")
        $0.backgroundColor = .red
    }
    private let startInputDesLabel = UILabel().then {
        $0.text = "출발지 입력*"
        $0.sizeToFit()
        $0.setColorForText(textForAttribute: "*", withColor: .red)
    }
    private let goalInputDesLabel = UILabel().then {
        $0.text = "도착지 입력*"
        $0.sizeToFit()
        $0.setColorForText(textForAttribute: "*", withColor: .red)
    }
    private let startLocateBtn = UIButton().then {
        $0.setTitle("어디서 출발하세요?", for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.setTitleColor(.bik30, for: .normal)
    }
    private let divideLine = DivideLine(type: .line)
    private let goalLocateBtn = UIButton().then {
        $0.setTitle("어디까지 가세요?", for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.setTitleColor(.bik30, for: .normal)
    }
    private let sideImge = UIImageView().then {
        $0.image = UIImage(named: "sideLocateImg")
    }
    private let chagneLocateBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "arrow-switch-horizontal"), for: .normal)
    }
    private let searchBtn = UIButton().then {
        $0.setTitle("검색", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .bik20
        $0.layer.cornerRadius = 16
    }
    private let locateVerticalFlexContainer = UIView()
    private let locateHorizontalFlexContainer = UIView()
    private let rootFlexContainer = UIView()

    // MARK: - Init & LifeCycle
    
    init(reactor: StartReactor) {
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
        self.bind(reactor: reactor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - SetUpUI
    
    override func configure() {
        navigationItem.title = "경로입력"
    }
    
    override func addView() {
        self.view.addSubview(scrollView)
         scrollView.addSubview(rootFlexContainer)
    }
    
    override func layout() {
        locateVerticalFlexContainer.flex
            .direction(.column)
            .alignItems(.stretch)
            .define { flex in
                flex.addItem(startInputDesLabel)
                    .marginLeft(0)
                flex.addItem(startLocateBtn)
                    .marginLeft(0)
                    .height(48)
                flex.addItem(divideLine)
                    .horizontally(0)
                    .height(1)
                flex.addItem(goalInputDesLabel)
                    .marginTop(21.5)
                    .marginLeft(0)
                flex.addItem(goalLocateBtn)
                    .marginLeft(0)
                    .height(48)
            }
        locateHorizontalFlexContainer.flex
            .direction(.row)
            .alignItems(.stretch)
            .define {  flex in
                flex.addItem(sideImge)
                    .marginTop(39)
                    .marginLeft(20)
                    .height(102)
                    .width(24)
                flex.addItem(locateVerticalFlexContainer)
                    .marginTop(32)
                    .marginLeft(20)
                    .marginRight(20)
                    .grow(1)
                flex.addItem(chagneLocateBtn)
                    .alignSelf(.center)
                    .width(24)
                    .height(24)
                    .marginRight(20)
            }
        rootFlexContainer.flex
            .direction(.column)
            .alignItems(.stretch)
            .define {  flex in
                flex.addItem(welecomeImg)
                    .marginTop(12)
                    .horizontally(0)
                    .height(327)
                flex.addItem(welecomeLabel)
                    .marginTop(40)
                    .marginLeft(20)
                flex.addItem(locateHorizontalFlexContainer)
                    .marginTop(32)
                    .marginLeft(0)
                    .marginRight(0)
                flex.addItem(searchBtn)
                    .marginTop(20)
                    .height(56)
                    .marginLeft(20)
                    .marginRight(20)
            }
        scrollView.pin.all()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout(mode: .adjustHeight)
        
        scrollView.contentSize = rootFlexContainer.frame.size
    }
    
    // MARK: - Bind
    
    private func bind(reactor: StartReactor) {
        startLocateBtn.rx.tap
            .map { StartReactor.Action.startLocationTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        goalLocateBtn.rx.tap
            .map { StartReactor.Action.goalLocationTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
