//
//  CurrentMarker.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 9/3/24.
//

import UIKit

import NMapsMap
import Then

final class CurrentMarker: NMFMarker {
    
    // MARK: - UI
    
    let startInfoWindow = NMFInfoWindow()
    
    // MARK: - initialization
    
    override init() {
        super.init()
        setUI()
        setInfoWindow()
    }
}

// MARK: - SetUI

extension CurrentMarker {
    private func setUI() {
        /// 마커의 아이콘 이미지 설정
        let image = NMFOverlayImage(name: "maker")
        self.iconImage = image
        
        self.width = CGFloat(NMF_MARKER_SIZE_AUTO)
        self.height = CGFloat(NMF_MARKER_SIZE_AUTO)
        
        self.anchor = CGPoint(x: 0.5, y: 1.0) /// 마커의 앵커 설정 (아래쪽 중앙을 기준으로 설정)
        
        self.iconPerspectiveEnabled = true
    }
    
    private func setInfoWindow() {
        /// 마커의 정보창 데이터 소스로 자신을 설정
        startInfoWindow.dataSource = self
    }
    
    func showInfoWindow() {
        startInfoWindow.open(with: self)
    }
    
    func hideInfoWindow() {
        startInfoWindow.close()
    }
}

// MARK: - NMFOverlayImageDataSource

extension CurrentMarker: NMFOverlayImageDataSource {
    func view(with overlay: NMFOverlay) -> UIView {
        /// 마커 위에 보여줄 InfoView 이미지 리턴
        let infoView = UIView(frame: CGRect(x: 0, y: 0, width: 179, height: 50))
        infoView.backgroundColor = .clear /// 배경색 설정
        
        /// 이미지 뷰 설정
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 179, height: 50)).then {
            $0.image = UIImage(named: "makerInfoView")
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFit
        }
        
        /// 텍스트 라벨 설정
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 179, height: 35)).then {
            $0.text  = "표시된 위치가 맞나요?"
            $0.textColor = .white
            $0.font = .suit(.Bold, size: 16)
            $0.textAlignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false

        }
        
        /// 뷰에 이미지와 텍스트 추가
        infoView.addSubview(imageView)
        imageView.addSubview(label)

        return infoView
    }
}
