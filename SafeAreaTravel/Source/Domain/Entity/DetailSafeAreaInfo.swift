//
//  DetailSafeAreaInfo.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 9/20/24.
//

import Foundation

// MARK: - 휴게소 세부 정보 Entity

struct DetailSafeArea: Equatable {
    let name: String
    var direction: String
    let isOperating: Bool
    let startTime: String
    let endTime: String
    let naverRating: Double
    let gasStationData: GasStationData
    let parkingData: ParkingData
    let reststopData: ReststopData
    let menuData: MenuData
    var openInfo: String?
    var safeAreaInfo: String?
}

extension DetailSafeArea {
    struct GasStationData: Equatable {
        let gasolinePrice: String
        let dieselPrice: String
        let lpgPrice: String
        let isElectricChargingStation: Bool
        let isHydrogenChargingStation: Bool
    }
    
    struct ParkingData: Equatable {
        let smallCarSpace: Int
        let largeCarSpace: Int
        let disabledPersonSpace: Int
        let totalSpace: Int
        let updateDate: String
    }
    
    struct ReststopData: Equatable {
        let restaurantOperatingTimes: [RestaurantOperatingTime]
        let brands: [Brand]
        let amenities: [Amenity]
        let address: String
        let phoneNumber: String
    }
    
    struct MenuData: Equatable {
        let representativeMenuData: [RepresentativeMenu]
        let totalMenuCount: Int
        let recommendedMenuData: [RecommendedMenu]
        let normalMenuData: [NormalMenu]
    }
}

// MARK: - ReststopData Extension

extension DetailSafeArea.ReststopData {
    
    struct RestaurantOperatingTime: Equatable {
        let restaurantName: String
        let operatingTime: String
    }
    
    struct Brand: Equatable {
        let brandName: String
        let brandLogoUrl: String
    }
    
    struct Amenity: Equatable {
        let amenityName: String
        let amenityLogoUrl: String
    }
}

// MARK: - MenuData Extension

extension DetailSafeArea.MenuData {
    
    struct RecommendedMenu: Equatable {
        let menuName: String
        let menuPrice: Int
        let isSignatureMenu: Bool
        let isPopularMenu: Bool
        let menuCategory: String
    }
    
    struct RepresentativeMenu: Equatable {
        let representativeMenuName: String
        let representativeMenuPrice: Int
        let representativeMenuImageUrl: String
        let representativeMenuDescription: String
    }
    
    struct NormalMenu: Equatable {
        let menuName: String
        let menuPrice: Int
        let isSignatureMenu: Bool
        let isPopularMenu: Bool
        let menuCategory: String
    }
}
