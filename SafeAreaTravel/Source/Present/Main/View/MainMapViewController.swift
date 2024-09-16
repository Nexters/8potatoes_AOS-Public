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
    private let nMapView = NMFMapView()
    private let pathOverlay = NMFPath().then {
        $0.color = .main100
        $0.width = 5
    }
    private var bottomSheet =  SafeAreaBottomSheet()
    private let searchBtn = LocationSearchFloatingBtn()
    
    // MARK: - Init & LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        presentBottomSheet()
    }
    
    init(reactor: MainMapReactor) {
        self.reactor = reactor
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
        /// 대한민국 중심 좌표를 설정
        let koreaCenter = NMGLatLng(lat: 36.5, lng: 127.5)
         
        /// 대한민국 전체가 보이도록 줌 레벨을 설정 (적절한 줌 레벨은 6~8 정도) 숫자가 낮을 수록 줌아웃
        let cameraUpdate = NMFCameraUpdate(scrollTo: koreaCenter, zoomTo: 6.4)
        nMapView.moveCamera(cameraUpdate)
        /// 줌을 고정해서 사용자가 변경하지 못하도록 설정
        nMapView.minZoomLevel = nMapView.cameraPosition.zoom
        nMapView.maxZoomLevel = nMapView.cameraPosition.zoom
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

    }
    
    private func bindAction(reactor: MainMapReactor) {
        searchBtn.startBtn.rx.tap
            .bind(onNext: {
                
            })
            .disposed(by: disposeBag)
        
        searchBtn.goalBtn.rx.tap
            .bind(onNext: {
                
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - presentBottomSheet

extension MainMapViewController {
    private func presentBottomSheet() {
        let bottomSheet = SafeAreaBottomSheet()
        bottomSheet.modalPresentationStyle = .pageSheet
        bottomSheet.modalTransitionStyle = .coverVertical

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
