//
//  TimeImageEnum.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 9/2/24.
//

import UIKit

/// 시간대에 따른 이미지를 지정하는 열거형
enum TimeImageEnum {
    case dayTime
    case evening
    case night
    
    var image: UIImage? {
        switch self {
        case .dayTime:
            return UIImage(named: "dayTimeStartBackgroundImg") // 낮 시간대에 사용할 이미지
        case .evening:
            return UIImage(named: "eveningStartBackgroundImg") // 저녁 시간대에 사용할 이미지
        case .night:
            return UIImage(named: "nightStartBackgroundImg") // 밤 시간대에 사용할 이미지
        }
    }
}
