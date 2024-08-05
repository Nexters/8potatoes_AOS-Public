//
//  SafeAraAPI.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import Foundation

import Moya

enum SafeAraAPI {
    case fetchDirction(start: Coordinate, goal: Coordinate)
    case fetchSearchLocationInfo(location: String, page:Int)
}
extension SafeAraAPI: TargetType {
    
    var baseURL: URL {
        switch self {
        case .fetchSearchLocationInfo:
            return URL(string: "https://apis.openapi.sk.com")!
        case .fetchDirction:
            return URL(string: "https://naveropenapi.apigw.ntruss.com")!
        }
    }
    
    var path: String {
        switch self {
        case .fetchSearchLocationInfo:
            return "/tmap/pois"
        case .fetchDirction:
            return "/map-direction/v1/driving"
        }
    }
    
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchSearchLocationInfo(let location, let page):
            return .requestParameters(parameters: [
                "version": "1",
                "page": page,
                "count": 10,
                "searchKeyword": location,
                "areaLLCode": "",
                "areaLMCode": "",
                "resCoordType": "WGS84GEO",
                "searchType": "all",
                "searchtypCd": "",
                "radius": "0",
                "reqCoordType": "WGS84GEO",
                "centerLon": "",
                "centerLat": "",
                "multiPoint": "",
                "callback": "",
            ], encoding: URLEncoding.default)
            
        default :
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
            
        case .fetchDirction:
            return ["X-NCP-APIGW-API-KEY-ID " : APIKeyManager.shared.nClientID,
                    "X-NCP-APIGW-API-KEY" : APIKeyManager.shared.nClientSecret]
        case .fetchSearchLocationInfo:
            return ["appKey": APIKeyManager.shared.tmapAPIKey]

        }
    }
}
