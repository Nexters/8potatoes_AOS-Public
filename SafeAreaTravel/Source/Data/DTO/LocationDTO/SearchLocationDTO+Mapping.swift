//
//  SearchLocationDTO+Mapping.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/29/24.
//

import Foundation

struct SearchPoiInfoRootDTO: ModelType {
    let searchPoiInfo: SearchPoiInfoDTO
}

struct SearchPoiInfoDTO: ModelType {
    let totalCount: String
    let count: String
    let page: String
    let pois: PoisDTO
}

struct PoisDTO: ModelType {
    let poi: [PoiDTO]
}

struct PoiDTO: ModelType {
    let id: String
    let pkey: String
    let navSeq: String
    let collectionType: String
    let name: String
    let telNo: String
    let frontLat: String
    let frontLon: String
    let noorLat: String
    let noorLon: String
    let upperAddrName: String
    let middleAddrName: String
    let lowerAddrName: String
    let mlClass: String
    let firstNo: String
    let secondNo: String
    let roadName: String
    let firstBuildNo: String
    let secondBuildNo: String
    let radius: String
    let upperBizName: String
    let middleBizName: String
    let lowerBizName: String
    let detailBizName: String
    let rpFlag: String
    let parkFlag: String
    let detailInfoFlag: String
    let desc: String
    let dataKind: String
    let zipCode: String
    let adminDongCode: String
    let legalDongCode: String
    let evChargers: EvChargersDTO
    let newAddressList: NewAddressListDTO
}

struct EvChargersDTO: ModelType {
    let evCharger: [EvChargerDTO]
}

struct EvChargerDTO: ModelType {
    let operatorId: String
    let stationId: String
    let chargerId: String
    let status: String
    let type: String
    let powerType: String
    let operatorName: String
    let chargingDateTime: String
    let updateDateTime: String
    let isFast: String
    let isAvailable: String
}

struct GroupSubDTO: ModelType {
    let subPkey: String
    let subSeq: String
    let subName: String
    let subCenterY: String
    let subCenterX: String
    let subNavY: String
    let subNavX: String
    let subRpFlag: String
    let subPoiId: String
    let subNavSeq: String
    let subParkYn: String
    let subClassCd: String
    let subClassNmA: String
    let subClassNmB: String
    let subClassNmC: String
    let subClassNmD: String
}

struct NewAddressListDTO: ModelType {
    let newAddress: [NewAddressDTO]
}

struct NewAddressDTO: ModelType {
    let centerLat: String
    let centerLon: String
    let frontLat: String
    let frontLon: String
    let roadName: String
    let bldNo1: String
    let bldNo2: String
    let roadId: String
    let fullAddressRoad: String
}

// MARK: - Mappings to Domain

extension SearchPoiInfoRootDTO {
    func toDomain() -> [SearchLocationModel] {
        return searchPoiInfo.pois.poi.map { poi in
            SearchLocationModel(
                frontLat: Double(poi.frontLat) ?? 0.0,
                frontLon: Double(poi.frontLon) ?? 0.0,
                name: poi.name,
                fullAddressRoad: poi.newAddressList.newAddress.first?.fullAddressRoad ?? "",
                fullAddressNum: "\(poi.upperAddrName) \(poi.middleAddrName) \(poi.lowerAddrName) \(poi.firstNo)-\(poi.secondNo)"
            )
        }
    }
}
