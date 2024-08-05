//
//  LocationDAO.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import Foundation

import RxSwift

final class LocationInfoDAO: LocationInfoRepository {
    
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
    
    func fetchRouteInfo(start: Coordinate, goal: Coordinate) -> Single<Route>  {
        return network
            .request(.fetchDirction(start: start, goal: goal))
            .map(RouteResponseDTO.self)
            .map { $0.route.toDomain() }
            .do(onSuccess: { (route) in
                log.debug("response FetchRouteInfo \(route)")
            }, onError: { error in
                log.error("Error occurred during fetchRouteInfo request: \(error.localizedDescription)")
            })
    }
    
    func searchLocation(location: String, page: Int) -> Single<[SearchLocationModel]> {
        return network
            .request(.fetchSearchLocationInfo(location: location, page: page))
            .map { response -> SearchPoiInfoRootDTO in
                do {
                    let decoder = JSONDecoder()
                    return try decoder.decode(SearchPoiInfoRootDTO.self, from: response.data)
                } catch {
                    log.error("Decoding error: \(error)")
                    if let jsonString = String(data: response.data, encoding: .utf8) {
                        log.error("Received JSON: \(jsonString)")
                    }
                    throw error
                }
            }
            .map { $0.toDomain() }
            .do(onSuccess: { (location) in
                log.debug("response SearchLocationToDomain")
            }, onError: { error in
                log.error("Error occurred during searchLocation request DAO: \(error.localizedDescription)")
            })
    }
}

