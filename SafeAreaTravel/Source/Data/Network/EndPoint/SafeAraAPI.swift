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
}
extension SafeAraAPI: TargetType {
    
    var baseURL: URL {
        switch self {
            
        case .fetchDirction:
            return URL(string: "https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving")!
        default :
            return URL(string: "")!
        }
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
            
        default :
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
            
        case .fetchDirction:
            return ["X-NCP-APIGW-API-KEY-ID " : APIKeyManager.shared.nClientID,
                    "X-NCP-APIGW-API-KEY" : APIKeyManager.shared.nClientSecret]
        }
    }
}
