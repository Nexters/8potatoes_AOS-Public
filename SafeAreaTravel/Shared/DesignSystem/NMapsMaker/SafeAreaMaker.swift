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
    private var textColor = UIColor.white
    
    // MARK: - initialization
    
    init(type: SafeAreaMakerType, text: String) {
        self.infoText = text
        super.init()
        setUI(type: type, text: text)
        setInfoWindow()
    }
    
    // MARK: - UI & Layout

    private func setUI(type: SafeAreaMakerType, text: String) {
        var baseImageName: String
        switch type {
        case .base:
            baseImageName = "safeAreaMaker"
            textColor = .main100
        case .middle:
            baseImageName = "middleSafeAreaMaker"
            textColor = .white
        }
        
        // 원본 이미지를 가져옵니다.
        guard let baseImage = UIImage(named: baseImageName) else {
            return
        }
        
        // 이미지의 좌우 끝부분의 너비를 설정합니다 (예: 10픽셀)
        let capInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        // 스케일 가능한 이미지로 변환합니다.
        let stretchableImage = baseImage.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
        
        // 텍스트의 길이에 따른 필요한 너비를 계산합니다.
        let font = UIFont.systemFont(ofSize: 16) // 폰트 설정 (필요에 따라 조정)
        let textAttributes = [NSAttributedString.Key.font: font]
        let textSize = (text as NSString).size(withAttributes: textAttributes)
        
        // 마커의 최소 및 최대 너비 설정
        let minWidth: CGFloat = 50
        let maxWidth: CGFloat = 200
        let padding: CGFloat = 20
        
        // 계산된 너비
        let calculatedWidth = textSize.width + padding
        let markerWidth = max(minWidth, min(calculatedWidth, maxWidth))
        
        // 마커의 아이콘 이미지 설정
        self.iconImage = NMFOverlayImage(image: stretchableImage)
        
        // 마커의 크기 설정
        self.width = markerWidth
        self.height = CGFloat(NMF_MARKER_SIZE_AUTO)
        
        // 앵커 설정 (필요에 따라 조정)
        self.anchor = CGPoint(x: 1, y: 0)
        safeAreaMakerInfoWindow.anchor = CGPoint(x: 1, y: 0)
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
        let infoView = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: 32))
        infoView.backgroundColor = .clear /// 배경색 설정

        
        // 텍스트 라벨 설정
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.width, height: 32)).then {
            $0.text  = infoText
            $0.textColor = textColor
            $0.font = .suit(.Bold, size: 16)
            $0.textAlignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false

        }
        
        // 뷰에 이미지와 텍스트 추가
        infoView.addSubview(label)

        return infoView
    }
}
