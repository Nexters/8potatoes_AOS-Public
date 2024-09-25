//
//  DetailSafeAreaInfo.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 9/20/24.
//

import Foundation

// MARK: - 휴게소 세부 정보 DTO

struct DetailSafeAreaDTO: ModelType {
    let name: String
    let direction: String
    let isOperating: Bool
    let startTime: String
    let endTime: String
    let naverRating: Double
    let gasStationData: GasStationDataDTO
    let parkingData: ParkingDataDTO
    let reststopData: ReststopDataDTO
    let menuData: MenuDataDTO
}

extension DetailSafeAreaDTO {
    struct GasStationDataDTO: ModelType {
        let gasolinePrice: String
        let dieselPrice: String
        let lpgPrice: String
        let isElectricChargingStation: Bool
        let isHydrogenChargingStation: Bool
    }
    
    struct ParkingDataDTO: ModelType {
        let smallCarSpace: Int
        let largeCarSpace: Int
        let disabledPersonSpace: Int
        let totalSpace: Int
        let updateDate: String
    }
    
    struct ReststopDataDTO: ModelType {
        let restaurantOperatingTimes: [RestaurantOperatingTimeDTO]
        let brands: [BrandDTO]
        let amenities: [AmenityDTO]
        let address: String
        let phoneNumber: String
    }
    
    struct MenuDataDTO: ModelType {
        let representativeMenuData: [RepresentativeMenuDTO]
        let totalMenuCount: Int
        let recommendedMenuData: [RecommendedMenuDTO]
        let normalMenuData: [NormalMenuDTO]
    }
}

// MARK: - ReststopDataDTO Extension

extension DetailSafeAreaDTO.ReststopDataDTO {
    
    struct RestaurantOperatingTimeDTO: ModelType {
        let restaurantName: String
        let operatingTime: String
    }
    
    struct BrandDTO: ModelType {
        let brandName: String
        let brandLogoUrl: String
    }
    
    struct AmenityDTO: ModelType {
        let amenityName: String
        let amenityLogoUrl: String
    }
}

// MARK: - MenuDataDTO Extension

extension DetailSafeAreaDTO.MenuDataDTO {
    
    struct RecommendedMenuDTO: ModelType {
        let menuName: String
        let menuPrice: Int
        let isSignatureMenu: Bool
        let isPopularMenu: Bool
        let menuCategory: String
    }
    
    struct RepresentativeMenuDTO: ModelType {
        let representativeMenuName: String
        let representativeMenuPrice: Int
        let representativeMenuImageUrl: String
        let representativeMenuDescription: String
    }
    
    struct NormalMenuDTO: ModelType {
        let menuName: String
        let menuPrice: Int
        let isSignatureMenu: Bool
        let isPopularMenu: Bool
        let menuCategory: String
    }
}

// MARK: - Mappings to Domain Extension

extension DetailSafeAreaDTO {
    func toDomain() -> DetailSafeArea {
        return .init(
            name: name,
            direction: direction,
            isOperating: isOperating,
            startTime: startTime,
            endTime: endTime,
            naverRating: naverRating,
            gasStationData: gasStationData.toDomain(),
            parkingData: parkingData.toDomain(),
            reststopData: reststopData.toDomain(),
            menuData: menuData.toDomain()
        )
    }
}

// MARK: - 하위 DTO -> Domain 변환 메서드

extension DetailSafeAreaDTO.GasStationDataDTO {
    func toDomain() -> DetailSafeArea.GasStationData {
        return .init(
            gasolinePrice: gasolinePrice,
            dieselPrice: dieselPrice,
            lpgPrice: lpgPrice,
            isElectricChargingStation: isElectricChargingStation,
            isHydrogenChargingStation: isHydrogenChargingStation
        )
    }
}

extension DetailSafeAreaDTO.ParkingDataDTO {
    func toDomain() -> DetailSafeArea.ParkingData {
        return .init(
            smallCarSpace: smallCarSpace,
            largeCarSpace: largeCarSpace,
            disabledPersonSpace: disabledPersonSpace,
            totalSpace: totalSpace,
            updateDate: updateDate
        )
    }
}

extension DetailSafeAreaDTO.ReststopDataDTO {
    func toDomain() -> DetailSafeArea.ReststopData {
        return .init(
            restaurantOperatingTimes: restaurantOperatingTimes.map { $0.toDomain() },
            brands: brands.map { $0.toDomain() },
            amenities: amenities.map { $0.toDomain() },
            address: address,
            phoneNumber: phoneNumber
        )
    }
}

extension DetailSafeAreaDTO.ReststopDataDTO.RestaurantOperatingTimeDTO {
    func toDomain() -> DetailSafeArea.ReststopData.RestaurantOperatingTime {
        return .init(
            restaurantName: restaurantName,
            operatingTime: operatingTime
        )
    }
}

extension DetailSafeAreaDTO.ReststopDataDTO.BrandDTO {
    func toDomain() -> DetailSafeArea.ReststopData.Brand {
        return .init(
            brandName: brandName,
            brandLogoUrl: brandLogoUrl
        )
    }
}

extension DetailSafeAreaDTO.ReststopDataDTO.AmenityDTO {
    func toDomain() -> DetailSafeArea.ReststopData.Amenity {
        return .init(
            amenityName: amenityName,
            amenityLogoUrl: amenityLogoUrl
        )
    }
}

extension DetailSafeAreaDTO.MenuDataDTO {
    func toDomain() -> DetailSafeArea.MenuData {
        return .init(
            representativeMenuData: representativeMenuData.map { $0.toDomain() },
            totalMenuCount: totalMenuCount,
            recommendedMenuData: recommendedMenuData.map { $0.toDomain() },
            normalMenuData: normalMenuData.map { $0.toDomain() }
        )
    }
}

extension DetailSafeAreaDTO.MenuDataDTO.RepresentativeMenuDTO {
    func toDomain() -> DetailSafeArea.MenuData.RepresentativeMenu {
        return .init(
            representativeMenuName: representativeMenuName,
            representativeMenuPrice: representativeMenuPrice,
            representativeMenuImageUrl: representativeMenuImageUrl,
            representativeMenuDescription: representativeMenuDescription
        )
    }
}

extension DetailSafeAreaDTO.MenuDataDTO.RecommendedMenuDTO {
    func toDomain() -> DetailSafeArea.MenuData.RecommendedMenu {
        return .init(
            menuName: menuName,
            menuPrice: menuPrice,
            isSignatureMenu: isSignatureMenu,
            isPopularMenu: isPopularMenu,
            menuCategory: menuCategory
        )
    }
}

extension DetailSafeAreaDTO.MenuDataDTO.NormalMenuDTO {
    func toDomain() -> DetailSafeArea.MenuData.NormalMenu {
        return .init(
            menuName: menuName,
            menuPrice: menuPrice,
            isSignatureMenu: isSignatureMenu,
            isPopularMenu: isPopularMenu,
            menuCategory: menuCategory
        )
    }
}
