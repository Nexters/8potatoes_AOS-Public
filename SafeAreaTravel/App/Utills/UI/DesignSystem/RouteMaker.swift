//
//  StartMaker.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 9/5/24.
//

import UIKit

import NMapsMap
import Then

/// 마커 타입
enum RouteMakerType {
    case start
    case goal
}

final class RouteMaker: NMFMarker {
    
    private lazy var makerImage = NMFOverlayImage(name: "startMaker")
    
    // MARK: - initialization
    init(type: RouteMakerType) {
        super.init()  
        setUI(type: type)
    }
}

// MARK: - UI & Layout

extension RouteMaker {
    private func setUI(type: RouteMakerType) {
        switch type {
        case .start:
            makerImage = NMFOverlayImage(name: "startMaker")
        case .goal:
            makerImage = NMFOverlayImage(name: "goalMaker")
        }

        self.iconImage = makerImage
        
        self.width = CGFloat(NMF_MARKER_SIZE_AUTO)
        self.height = CGFloat(NMF_MARKER_SIZE_AUTO)
        
        self.anchor = CGPoint(x: 0.5, y: 1.0) /// 마커의 앵커 설정 (아래쪽 중앙을 기준으로 설정)
        
        self.iconPerspectiveEnabled = true
    }
}
