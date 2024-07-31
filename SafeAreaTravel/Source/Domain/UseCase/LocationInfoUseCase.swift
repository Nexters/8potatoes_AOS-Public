//
//  LocationInfoUseCase.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import RxSwift

protocol LocationInfoUseCaseProtocol {
    func fetchRouteInfo(start: Coordinate, goal: Coordinate) -> Single<Route>
    func searchLocation(location: String, page: Int) -> Single<[SearchLocationModel]>
}
final class LocationInfoUseCase: LocationInfoUseCaseProtocol {
    
    
    private let repository: LocationInfoRepository
    
    init(repository: LocationInfoRepository) {
        self.repository = repository
    }
    
    func fetchRouteInfo(start: Coordinate, goal: Coordinate) -> RxSwift.Single<Route> {
        return repository
            .fetchRouteInfo(start: start,
                            goal: goal)
    }
    
    func searchLocation(location: String, page: Int) -> RxSwift.Single<[SearchLocationModel]> {
        return repository
            .searchLocation(location: location, page: page)
    }
}

