//
//  SafeAreaInfo.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 9/15/24.
//

import Foundation

struct SafeAreaListInfo: Equatable {
    let totalReststopCount: Int
    let reststops: [SafeAreaInfo]
}
extension SafeAreaListInfo {
    struct SafeAreaInfo: Equatable {
        let name: String
        let direction: String
        let code: String
        let isOperating: Bool
        let gasolinePrice: String?
        let dieselPrice: String?
        let lpgPrice: String?
        let naverRating: Double
        let foodMenusCount: Int
        let location: Coordinate
        let isRecommend: Bool
    }

}

