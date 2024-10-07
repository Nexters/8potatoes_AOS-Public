//
//  SafeAraAPI.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import Foundation

import Moya

enum SafeAraAPI {
    case fetchDirction(start: String, goal: String)
    case fetchSearchLocationInfo(location: String, page:Int)
    case fetchReverseGeocoding(lat: Double, lon: Double)
    case fetchSafeAreaList(start: String, goal: String, highWayInfo: [String: [[[Double]]]])
    case fetchSafeAreaInfo(code: String)
}
extension SafeAraAPI: TargetType {
    
    var baseURL: URL {
        switch self {
        case .fetchSearchLocationInfo, .fetchReverseGeocoding:
            return URL(string: "https://apis.openapi.sk.com")!  /// TmapAPI baseURL
        case .fetchDirction:
            return URL(string: "https://naveropenapi.apigw.ntruss.com")!    ///NaverMap baseURL
        default :
            return URL(string: "https://server-hyusik-matju.site/api")!     /// 휴식맞쥬 baseURL
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
        case .fetchSafeAreaInfo:
            return "/reststop/info"
        }
    }
    
    
    var method: Moya.Method {
        switch self {
        case .fetchSafeAreaList:
            return .post
        
        default:
            return .get
        }
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
                "start": start,
                "goal": goal
            ], encoding: URLEncoding.default)
            
        case .fetchSafeAreaList(let start, let goal, let highWayInfo):
            // 좌표를 URL 인코딩하여 쿼리 파라미터로 설정
            let parameters: [String: String] = [
                "from": start.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? start,
                "to": goal.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? goal
            ]
            let highWayInfos: [String: [[[Double]]]] = [
                "경부 고속도로": [
                    [
                        [127.08543779752235, 37.21774152026536],
                        [127.09485641007603, 37.21774152026536],
                        [127.08543779752235, 37.21632224543946],
                        [127.09485641007603, 37.21632224543946]
                    ],
                    [
                        [127.0871670924697, 37.21640850022002],
                        [127.09624519973312, 37.21640850022002],
                        [127.0871670924697, 37.15722910006451],
                        [127.09624519973312, 37.15722910006451]
                    ],
                    [
                        [127.08338161645169, 37.15722910006451],
                        [127.12021299657435, 37.15722910006451],
                        [127.08338161645169, 37.097153303863195],
                        [127.12021299657435, 37.097153303863195]
                    ],
                    [
                        [127.12021299657435, 37.097153303863195],
                        [127.18206690562984, 37.097153303863195],
                        [127.12021299657435, 36.95515413954567],
                        [127.18206690562984, 36.95515413954567]
                    ],
                    [
                        [127.18206690562984, 36.95515413954567],
                        [127.18941657136901, 36.95515413954567],
                        [127.18206690562984, 36.91536996091402],
                        [127.18941657136901, 36.91536996091402]
                    ],
                    [
                        [127.16500035086526, 36.91536996091402],
                        [127.42900810258438, 36.91536996091402],
                        [127.16500035086526, 36.56970289866972],
                        [127.42900810258438, 36.56970289866972]
                    ],
                    [
                        [129.00405029959754, 35.9232721259512],
                        [129.1969267252899, 35.9232721259512],
                        [129.00405029959754, 35.59629209533116],
                        [129.1969267252899, 35.59629209533116]
                    ],
                    [
                        [129.0439018077258, 35.59629209533116],
                        [129.13935314471962, 35.59629209533116],
                        [129.0439018077258, 35.344940811027634],
                        [129.13935314471962, 35.344940811027634]
                    ],
                    [
                        [129.03975235183123, 35.344940811027634],
                        [129.0439018077258, 35.344940811027634],
                        [129.03975235183123, 35.33833869788435],
                        [129.0439018077258, 35.33833869788435]
                    ],
                    [
                        [129.03964406257919, 35.33833869788435],
                        [129.10871479516058, 35.33833869788435],
                        [129.03964406257919, 35.25344378370259],
                        [129.10871479516058, 35.25344378370259]
                    ],
                    [
                        [129.0967886603519, 35.25344378370259],
                        [129.09981890169848, 35.25344378370259],
                        [129.0967886603519, 35.24898872371351],
                        [129.09981890169848, 35.24898872371351]
                    ]
                ]
            ]

            // 바디에 고속도로 데이터를 포함 (JSON 포맷)
            let bodyParameters: [String: Any] = [
                "highways": highWayInfo
            ]
            
            // 쿼리 파라미터와 바디 파라미터를 함께 전송
            return .requestCompositeParameters(
                bodyParameters: bodyParameters,
                bodyEncoding: JSONEncoding.default,
                urlParameters: parameters
            )
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
        case .fetchSafeAreaInfo:
            return [ "accept" : "application/json"]
        default:
            return [ "accept" : "application/json",
                     "Content-Type": "application/json"]
        }
    }
}
