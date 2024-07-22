//
//  LocationDAO.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

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
                log.debug("response \(route)")
            })
    }
}

