//
//  SafeAreaMaker.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 10/12/24.
//

import UIKit

import NMapsMap
import Then

/// 마커 타입
enum SafeAreaMakerType {
    case base
    case middle
}

final class SafeAreaMaker: NMFMarker {
    
    let safeAreaMakerInfoWindow = NMFInfoWindow()
    private var infoText = ""
    
    // MARK: - initialization
    
    init(type: SafeAreaMakerType, text: String) {
        self.infoText = text
        super.init()
        setUI(type: type, text: text)
        setInfoWindow()
    }
    
    // MARK: - UI & Layout

    private func setUI(type: SafeAreaMakerType, text: String) {
        switch type {
            
        case .base:
            self.iconImage = NMFOverlayImage(name: "safeAreaMaker")
        case .middle:
            self.iconImage = NMFOverlayImage(name: "middleSafeAreaMaker")
        }
        
        self.width = CGFloat(NMF_MARKER_SIZE_AUTO)
        self.height = CGFloat(NMF_MARKER_SIZE_AUTO)
        
        self.anchor = CGPoint(x: 1, y: 0) // 마커의 앵커 설정 (왼쪽 아래를 기준)
        
        self.iconPerspectiveEnabled = true
    }
    private func setInfoWindow() {
        // 마커의 정보창 데이터 소스로 자신을 설정
        safeAreaMakerInfoWindow.dataSource = self
    }
    
    func showInfoWindow() {
        safeAreaMakerInfoWindow.open(with: self)
    }
    
    func hideInfoWindow() {
        safeAreaMakerInfoWindow.close()
    }
}

// MARK: - NMFOverlayImageDataSource

extension SafeAreaMaker: NMFOverlayImageDataSource {
    func view(with overlay: NMFOverlay) -> UIView {
        // 마커 위에 보여줄 InfoView 이미지 리턴
        let infoView = UIView(frame: CGRect(x: 0, y: 0, width: 173, height: 32))
        infoView.backgroundColor = .clear /// 배경색 설정

        
        // 텍스트 라벨 설정
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 173, height: 32)).then {
            $0.text  = infoText
            $0.textColor = .main100
            $0.font = .suit(.Bold, size: 16)
            $0.textAlignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false

        }
        
        // 뷰에 이미지와 텍스트 추가
        infoView.addSubview(label)

        return infoView
    }
}
