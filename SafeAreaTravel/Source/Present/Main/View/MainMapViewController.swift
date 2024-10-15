//
//  MainMapViewController.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import UIKit

import PinLayout
import NMapsMap
import RxCocoa
import ReactorKit

final class MainMapViewController: BaseViewController, View {
    
    // MARK: - Properties

    private let reactor: MainMapReactor
    var disposeBag =  DisposeBag()

    // MARK: - UI
    
    private let startMaker = RouteMaker(type: .start)
    private let goalMaker = RouteMaker(type: .goal)
    private var safeAreaMakers: [SafeAreaMaker] = []
    private let nMapView = NMFMapView()
    private let pathOverlay = NMFPath().then {
        $0.color = .main100
        $0.width = 5
    }
    private var bottomSheet =  SafeAreaBottomSheet(info: SafeAreaListInfo(totalReststopCount: 0, reststops: []))
    private let searchBtn = LocationSearchFloatingBtn()
    
    // MARK: - Init & LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    init(reactor: MainMapReactor) {
        self.reactor = reactor
        reactor.action.onNext(.viewDidLoad)
        super.init(nibName: nil, bundle: nil)
        bind(reactor: reactor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetUpUI
    
    override func  configure() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        pathOverlay.mapView = nMapView
        // 대한민국 중심 좌표를 설정
        let koreaCenter = NMGLatLng(lat: 36.5, lng: 127.5)
         
        // 대한민국 전체가 보이도록 줌 레벨을 설정 (적절한 줌 레벨은 6~8 정도) 숫자가 낮을 수록 줌아웃
        let cameraUpdate = NMFCameraUpdate(scrollTo: koreaCenter, zoomTo: 6.4)
        nMapView.moveCamera(cameraUpdate)
        // 줌을 고정해서 사용자가 변경하지 못하도록 설정
    }
    
    override func addView() {
        self.view.addSubview(nMapView)
        [searchBtn].forEach {
            nMapView.addSubview($0)
        }
    }
    
    override func layout() {
        nMapView.pin.all()
        
        searchBtn.pin
            .top(40)
            .height(48)
            .horizontally(16)
    }
    
    // MARK: - Bind
    
    func bind(reactor: MainMapReactor) {
        bindState(reactor: reactor)
        bindAction(reactor: reactor)
    }
    
    private func bindState(reactor: MainMapReactor) {
        reactor.state
            .map {$0.startLocation}
            .asDriver(onErrorJustReturn: reactor.initialState.startLocation)
            .drive(onNext: {  [weak self] startLocation in
                self?.searchBtn.startBtn.setTitle(startLocation.name, for: .normal)
                self?.startMaker.position = NMGLatLng(lat: startLocation.frontLat,
                                                      lng: startLocation.frontLon)
                self?.startMaker.mapView = self?.nMapView
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map {$0.goalLocation}
            .asDriver(onErrorJustReturn: reactor.initialState.goalLocation)
            .drive(onNext: {  [weak self] goalLocation in
                self?.searchBtn.goalBtn.setTitle(goalLocation.name, for: .normal)
                self?.goalMaker.position = NMGLatLng(lat: goalLocation.frontLat,
                                                     lng: goalLocation.frontLon)
                self?.goalMaker.mapView = self?.nMapView
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.route }
            .asDriver(onErrorJustReturn: reactor.initialState.route)
            .drive(onNext: { [weak self] route in
                let points = route.trafast[0].path.map { NMGLatLng(lat: $0[1], lng: $0[0]) }
                self?.pathOverlay.path = NMGLineString(points: points)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map {$0.safeAreaList}
            .asDriver(onErrorJustReturn: reactor.initialState.safeAreaList)
            .drive(onNext: {  [weak self] info in
                self?.presentBottomSheet(info: info)
                self?.updateSafeAreaMarkers(with: info.reststops)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAction(reactor: MainMapReactor) {
        searchBtn.startBtn.rx.tap
            .bind(onNext: {
                reactor.action.onNext(.changeStartLocation)
            })
            .disposed(by: disposeBag)
        
        searchBtn.goalBtn.rx.tap
            .bind(onNext: {
                reactor.action.onNext(.changeGoalLocation)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Private Method

extension MainMapViewController {
    private func updateSafeAreaMarkers(with safeAreaList: [SafeAreaListInfo.SafeAreaInfo]) {
        
        //기존 마커 초기화
        for maker in safeAreaMakers {
            maker.mapView = nil
        }
        safeAreaMakers.removeAll()
        let n = safeAreaList.count
        let middleIndics = n.getMiddleIndices(count: n)
        
        for (index, safeArea) in safeAreaList.enumerated() {
            let makerType: SafeAreaMakerType = middleIndics.contains(index) ? .middle : .base
            let maker = SafeAreaMaker(type: makerType,
                                      text: safeArea.name)
            
            maker.position =  NMGLatLng(lat: safeArea.location.lat,
                                        lng: safeArea.location.lon)
            maker.mapView = nMapView
            safeAreaMakers.append(maker)
        }
    }
}

//MARK: - presentBottomSheet

extension MainMapViewController {
    private func presentBottomSheet(info: SafeAreaListInfo) {
        bottomSheet = SafeAreaBottomSheet(info: info)
        bottomSheet.modalPresentationStyle = .pageSheet
        bottomSheet.modalTransitionStyle = .coverVertical
        
        bottomSheet.selectedCellRelay
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: {  [weak self]  code in
                self?.reactor.action.onNext(.safeAreaListTapped(code))
            })
            .disposed(by: disposeBag)

        if let sheetPresentationController = bottomSheet.sheetPresentationController {
            let customMediumDetent = UISheetPresentationController.Detent.custom { context in
                return context.maximumDetentValue * 0.25
            }

            sheetPresentationController.detents = [customMediumDetent, .medium(), .large()]
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.largestUndimmedDetentIdentifier = .large
        }
        present(bottomSheet, animated: true, completion: nil)
    }
}
