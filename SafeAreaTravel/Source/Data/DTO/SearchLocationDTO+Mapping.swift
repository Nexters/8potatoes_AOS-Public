//
//  SearchLocationDTO+Mapping.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/29/24.
//

import Foundation

struct SearchPoiInfoDTO: ModelType {
    let totalCount: String
    let count: String
    let page: String
    let pois: PoisDTO
}

extension SearchPoiInfoDTO {
    struct PoisDTO: ModelType {
        let poi: [PoiDTO]
    }
}

extension SearchPoiInfoDTO.PoisDTO {
    struct PoiDTO: ModelType {
        let id: String
        let pkey: String
        let navSeq: String
        let collectionType: String
        let name: String
        let frontLat: String
        let frontLon: String
        let noorLat: String
        let noorLon: String
        let upperAddrName: String
        let middleAddrName: String
        let lowerAddrName: String
        let detailAddrname: String
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
        let buildingName: String
        let evChargers: EvChargersDTO
        let groupSubLists: GroupSubListsDTO
        let newAddressList: NewAddressListDTO
    }
}

extension SearchPoiInfoDTO.PoisDTO.PoiDTO {
    struct EvChargersDTO: ModelType {
        let evChargerDTO: [EvChargerDTO]
    }
}

extension SearchPoiInfoDTO.PoisDTO.PoiDTO.EvChargersDTO {
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
}

extension SearchPoiInfoDTO.PoisDTO.PoiDTO {
    struct GroupSubListsDTO: ModelType {
        let groupSub: [GroupSubDTO]
    }
}

extension SearchPoiInfoDTO.PoisDTO.PoiDTO.GroupSubListsDTO {
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
}

extension SearchPoiInfoDTO.PoisDTO.PoiDTO {
    struct NewAddressListDTO: ModelType {
        let newAddress: [NewAddressDTO]
    }
}

extension SearchPoiInfoDTO.PoisDTO.PoiDTO.NewAddressListDTO {
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
}

// MARK: - Mappings to Domain

extension SearchPoiInfoDTO {
    func toDomain() -> [SearchLocationModel] {
        return pois.poi.map { poi in
            SearchLocationModel(
                frontLat: Double(poi.frontLat) ?? 0.0,
                frontLon: Double(poi.frontLon) ?? 0.0,
                name: poi.name,
                fullAddressRoad: poi.newAddressList.newAddress[0].fullAddressRoad,
                fullAddressNum: "\(poi.upperAddrName) \(poi.middleAddrName) \(poi.lowerAddrName) \(poi.firstBuildNo)-\(poi.secondBuildNo)\(poi.detailAddrname)"
            )
        }
    }
}
