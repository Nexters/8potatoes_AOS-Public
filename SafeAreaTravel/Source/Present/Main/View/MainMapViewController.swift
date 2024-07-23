//
//  MainMapViewController.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import UIKit

import NMapsMap
import RxCocoa
import ReactorKit
import FloatingPanel

final class MainMapViewController: BaseViewController {
    var position: FloatingPanel.FloatingPanelPosition
    
    var initialState: FloatingPanel.FloatingPanelState
    
    var anchors: [FloatingPanel.FloatingPanelState : any FloatingPanel.FloatingPanelLayoutAnchoring]
    
    // MARK: - Properties

    private let reactor: MainMapReactor
    private var floatingPanel: FloatingPanelController!

    // MARK: - UI
    private let nMapView = NMFMapView()
    private var bottomSheetVC: SafeAreaBottomSheet!


    // MARK: - Init & LifeCycle
    init(reactor: MainMapReactor) {
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetUpUI
    
    override func  configure() {
        showBottomSheet()
    }
    
    override func addView() {
        self.view.addSubview(nMapView)
    }
    
    override func layout() {
        nMapView.pin.all()
    }
    
    private func showBottomSheet() {
         let bottomSheetVC = SafeAreaBottomSheet()
         
         floatingPanel = FloatingPanelController()
         floatingPanel.delegate = self
         floatingPanel.set(contentViewController: bottomSheetVC)
         floatingPanel.addPanel(toParent: self)
         
         // 패널의 레이아웃 및 초기 위치 설정
         //floatingPanel.layout = CustomFloatingPanelLayout()
     }

    // MARK: - Bind
    
    private func bind(reactor: MainMapReactor) {
        
    }
}
extension MainMapViewController: FloatingPanelControllerDelegate, FloatingPanelLayout {
    // MARK: - Bottom Sheet
    private func setupBottomSheet() {
        bottomSheetVC = SafeAreaBottomSheet()
        floatingPanel = FloatingPanelController()
        floatingPanel.delegate = self
        floatingPanel.layout = self
        floatingPanel.set(contentViewController: bottomSheetVC)
        floatingPanel.addPanel(toParent: self)

        // 초기 컨텐츠 설정
    }

    private func showBottomSheet() {
        floatingPanel.move(to: .tip, animated: false)
    }

    // MARK: - FloatingPanelLayout
    var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    var supportedPositions: Set<FloatingPanelPosition> {
        return [.tip, .full]
    }
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 60.0
        case .tip: return 300.0
        default: return nil
        }
    }
}
