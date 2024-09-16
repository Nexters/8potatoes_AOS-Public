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
    case fetchReverseGeocoding(lat: Double, lon: Double)
    case fetchSafeAreaList(start: String, goal: String, route: Route)
}
extension SafeAraAPI: TargetType {
    
    var baseURL: URL {
        switch self {
        case .fetchSearchLocationInfo, .fetchReverseGeocoding:
            return URL(string: "https://apis.openapi.sk.com")!
        case .fetchDirction:
            return URL(string: "https://naveropenapi.apigw.ntruss.com")!
        case .fetchSafeAreaList:
            return URL(string: "http://server-hyusik-matju.site/api")!
        }
    }
    
    var path: String {
        switch self {
        case .fetchSearchLocationInfo:
            return "/tmap/pois"
        case .fetchDirction:
            return "/map-direction/v1/driving"
        case .fetchReverseGeocoding:
            return "/tmap/geo/reversegeocoding"
        case .fetchSafeAreaList:
            return "/highways/reststops"
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
        case .fetchReverseGeocoding(let lat, let lon):
            return .requestParameters(parameters: [
                "version": "1",
                "lat": lat,
                "lon": lon,
                "coordType": "WGS84GEO",  /// 경위도
                "addressType": "A10", /// 주소 타입 - A00: 행정동,법정동 주소 - A01: 행정동 주소 - A02: 법정동 주소 - A03: 도로명 주소 - A04: 건물 번호 - A10: 행정동, 법정동, 도로명 주소
            ], encoding: URLEncoding.default)
            
        case .fetchDirction(let start, let goal):
            return .requestParameters(parameters: [
                "start": "127.12345,37.12345",
                "goal": "127.8157298,35.5597367"
            ], encoding: URLEncoding.default)
            
        default :
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
            
        case .fetchDirction:
            return ["X-NCP-APIGW-API-KEY-ID" : APIKeyManager.shared.nClientID,
                    "X-NCP-APIGW-API-KEY" : APIKeyManager.shared.nClientSecret,
            ]
        case .fetchSearchLocationInfo:
            return ["appKey": APIKeyManager.shared.tmapAPIKey]
        case .fetchReverseGeocoding:
            return [ "accept" : "application/json",
                     "appKey": APIKeyManager.shared.tmapAPIKey]

        default:
            return nil
        }
    }
}
