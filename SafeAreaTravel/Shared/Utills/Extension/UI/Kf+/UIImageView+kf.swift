//
//  UIImageView+Extension.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 8/25/24.
//

import Kingfisher
import UIKit

extension UIImageView {
    
    enum ImageCategory: String {
        case brand = "brand"
        case menu = "menu"
        case amenities = "amenities"
    }
    
    /// 카테고리와 이미지 이름을 넣으면 자동으로 URL을 구성하고 이미지를 로드하는 함수
    func setImage(category: ImageCategory, imageName: String) {
        let baseURL = "https://kr.object.ncloudstorage.com/8potatoes/"
        let urlString = "\(baseURL)\(category.rawValue)/\(imageName).svg"
        
        guard let url = URL(string: urlString) else {
            print("잘못된 URL입니다: \(urlString)")
            return
        }
    
        self.kf.setImage(with: url)
    }
}
