//
//  SafeAreaDTO+Mapping.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 9/5/24.
//

import Foundation

/// 경로상 존재하는 휴게소정보 DTO

struct SafeAreaDTO: ModelType {
    let totalReststopCount: Int
    let reststops: [ReststopDTO]
}

extension SafeAreaDTO {
    struct ReststopDTO: ModelType {
        let name: String
        let direction: String?
        let code: String
        let isOperating: Bool
        let gasolinePrice: String?
        let dieselPrice: String?
        let lpgPrice: String?
        let naverRating: Double
        let foodMenusCount: Int
        let location: LocationDTO
        let isRecommend: Bool
    }
}

extension SafeAreaDTO.ReststopDTO {
    struct LocationDTO: ModelType {
        let latitude: Double
        let longitude: Double
    }
}

// MARK: - Mappings to Domain

extension SafeAreaDTO {
    func toDomain() -> SafeAreaListInfo {
        return .init(
            totalReststopCount: totalReststopCount,
            reststops: reststops.map { $0.toDomain() }
        )
    }
}

extension SafeAreaDTO.ReststopDTO {
    func toDomain() -> SafeAreaListInfo.SafeAreaInfo {
        return .init(
            name: name,
            direction: direction ?? "",
            code: code,
            isOperating: isOperating,
            gasolinePrice: gasolinePrice,
            dieselPrice: dieselPrice,
            lpgPrice: lpgPrice,
            naverRating: naverRating,
            foodMenusCount: foodMenusCount,
            location: .init(lat: location.latitude, lon: location.longitude),
            isRecommend: isRecommend
        )
    }
}
