//
//  LocationInfoUseCase.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import RxSwift

enum LocationEvent {
    case selectLocation(SearchLocationModel)
}

protocol LocationInfoUseCaseProtocol {
    func fetchRouteInfo(start: Coordinate, goal: Coordinate) -> Single<Route>
    func searchLocation(location: String, page: Int) -> Single<[SearchLocationModel]>
    var event: PublishSubject<LocationEvent> { get }
    func selectLocation(location: SearchLocationModel)
}

final class LocationInfoUseCase: LocationInfoUseCaseProtocol {
    let event = PublishSubject<LocationEvent>()
    private let repository: LocationInfoRepository
    
    init(repository: LocationInfoRepository) {
        self.repository = repository
    }
    
    func fetchRouteInfo(start: Coordinate, goal: Coordinate) -> Single<Route> {
        return repository.fetchRouteInfo(start: start, goal: goal)
    }
    
    func searchLocation(location: String, page: Int) -> Single<[SearchLocationModel]> {
        return repository.searchLocation(location: location, page: page)
    }
    
    func selectLocation(location: SearchLocationModel) {
        event.onNext(.selectLocation(location))
    }
}

