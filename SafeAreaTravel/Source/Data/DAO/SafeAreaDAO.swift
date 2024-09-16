//
//  SafeAreaDAO.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 9/5/24.
//

import RxSwift
import Foundation

final class SafeAreaDAO: SafeAreaInfoRepository {
    
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
    
    func fetchSafeAreaList(start: Coordinate, goal: Coordinate, route: Route) -> Single<SafeAreaListInfo> {
        let startCoord = "\(start.lon),\(start.lat)"
        let goalCoord = "\(goal.lon),\(goal.lat)"
        return network
            .request(.fetchSafeAreaList(start: startCoord, goal: goalCoord, route: route))
            .map { response -> SafeAreaDTO in
                do {
                    let decoder = JSONDecoder()
                    return try decoder.decode(SafeAreaDTO.self, from: response.data)
                } catch {
                        log.error("Decoding error: \(error)")
                    if let jsonString = String(data: response.data, encoding: .utf8) {
                        log.error("Received JSON: \(jsonString)")
                    }
                    throw error
                }
            }
            .map { $0.toDomain() }
            .do(onSuccess: { (route) in
                log.debug("response fetchSafeAreaList \(route)")
            }, onError: { error in
                log.error("Error occurred during fetchSafeAreaList request: \(error.localizedDescription)")
            })
    }
}
