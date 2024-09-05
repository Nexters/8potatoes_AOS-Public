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
    func searchLocationToCoordinate(lat: Double, lon: Double) -> Single<SearchLocationModel>
    var event: PublishSubject<LocationEvent> { get }
    func selectLocation(location: SearchLocationModel) -> Observable<SearchLocationModel>
}

final class LocationInfoUseCase: LocationInfoUseCaseProtocol {
    
    func selectLocation(location: SearchLocationModel) -> RxSwift.Observable<SearchLocationModel> {
        log.debug("LocationInfoUseCase - selectLocation: \(location)")
        event.onNext(.selectLocation(location))
        return .just(location)
    }
    
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
            .map { models in
                return models.map { $0.cleaned() }
            }
    }
    
    func searchLocationToCoordinate(lat: Double, lon: Double) -> RxSwift.Single<SearchLocationModel> {
        return repository.searchLocationToCoordinate(lat: lat, lon: lon)
    }
}

