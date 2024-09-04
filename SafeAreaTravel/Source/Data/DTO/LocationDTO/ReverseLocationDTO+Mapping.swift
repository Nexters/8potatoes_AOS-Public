//
//  ReverseLocationDTO+Mapping.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 9/4/24.
//

import Foundation

struct ReverseLocationDTO: ModelType {
    let addressInfo: AddressInfoDTO
   
}
extension ReverseLocationDTO {
    struct AddressInfoDTO: ModelType {
        let fullAddress: String
        let addressType: String
        let cityDo: String
        let guGun: String
        let eupMyun: String
        let adminDong: String
        let adminDongCode: String
        let legalDong: String
        let legalDongCode: String
        let ri: String
        let bunji: String
        let roadName: String
        let buildingIndex: String
        let buildingName: String
        let mappingDistance: String
        let roadCode: String
        
        enum CodingKeys: String, CodingKey {
            case fullAddress
            case addressType
            case cityDo = "city_do"
            case guGun = "gu_gun"
            case eupMyun = "eup_myun"
            case adminDong
            case adminDongCode
            case legalDong
            case legalDongCode
            case ri
            case bunji
            case roadName
            case buildingIndex
            case buildingName
            case mappingDistance
            case roadCode
        }
    }
}

// MARK: - Mappings to Domain

extension ReverseLocationDTO {
    func toDomain(lat: Double, lon: Double) -> SearchLocationModel {
        return .init(frontLat: lat,
                     frontLon: lon,
                     name: addressInfo.buildingName,
                     fullAddressRoad: addressInfo.fullAddress,
                     fullAddressNum: addressInfo.fullAddress)
    }
}
