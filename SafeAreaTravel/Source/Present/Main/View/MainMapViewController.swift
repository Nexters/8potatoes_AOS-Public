//
//  MainMapViewController.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import UIKit

import SnapKit
import PinLayout
import NMapsMap
import RxCocoa
import ReactorKit

final class MainMapViewController: BaseViewController {
    
    // MARK: - Properties

    private let reactor: MainMapReactor
    

    // MARK: - UI
    private let nMapView = NMFMapView()
    private var bottomSheet =  SafeAreaBottomSheet()
    private let searchBtn = LocationSearchFloatingBtn()
    
    // MARK: - Init & LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        presentBottomSheet()
    }
    
    init(reactor: MainMapReactor) {
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetUpUI
    
    override func  configure() {
        
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
            .height(40)
            .horizontally(16)
    }
    
    // MARK: - Bind
    private func bind(reactor: MainMapReactor) {
        
    }
    
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
