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
                "version": "1", // Use appropriate version
                "page": page,
                "count": 10, // Default or specify count
                "searchKeyword": location,
                "areaLLCode": "", // Optional or specify code
                "areaLMCode": "", // Optional or specify code
                "resCoordType": "WGS84GEO", // Example, change if necessary
                "searchType": "A", // Example, change if necessary
                "searchtypCd": "", // Optional or specify code
                "radius": "2000", // Example radius
                "reqCoordType": "WGS84GEO", // Example, change if necessary
                "centerLon": "", // Specify if needed
                "centerLat": "", // Specify if needed
                "multiPoint": "", // Specify if needed
                "callback": "", // Optional callback parameter
                "appKey": APIKeyManager.shared.tmapAPIKey // Your Tmap API Key
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
        case .fetchSearchLocationInfo(location: let location, page: let page):
            return nil
        }
    }
}
