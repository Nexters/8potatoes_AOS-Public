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

final class MainMapViewController: BaseViewController {
    // MARK: - Properties

    
    // MARK: - UI
    private let nMapView = NMFMapView()

    // MARK: - Init & LifeCycle
    
    
    // MARK: - SetUpUI
    override func addView() {
        self.view.addSubview(nMapView)
        [].forEach {
            nMapView.addSubview($0)
        }
    }
    
    override func layout() {
        nMapView.pin
            .all()
    }

    
    // MARK: - Bind
    
    private func bind(reactor: MainMapReactor) {
        
    }
}
