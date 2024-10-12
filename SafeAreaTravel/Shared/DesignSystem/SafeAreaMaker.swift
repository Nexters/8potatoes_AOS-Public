//
//  SafeAreaMaker.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 10/12/24.
//

import UIKit

import NMapsMap
import Then

final class SafeAreaMaker: NMFMarker {
    
    private lazy var makerImage = NMFOverlayImage(name: "startMaker")
    
    // MARK: - initialization
    
    override init() {
        super.init()
        setUI()
    }
    
    // MARK: - UI & Layout

    private func setUI() {
        self.iconImage = makerImage
        
        self.width = CGFloat(NMF_MARKER_SIZE_AUTO)
        self.height = CGFloat(NMF_MARKER_SIZE_AUTO)
        
        self.anchor = CGPoint(x: 0.5, y: 1.0) /// 마커의 앵커 설정 (아래쪽 중앙을 기준으로 설정)
        
        self.iconPerspectiveEnabled = true
    }
}


