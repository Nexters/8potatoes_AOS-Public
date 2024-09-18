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
            .map { route in
                /// 고속도로 경로 추출
                let highwayPaths = self.extractHighwayPaths(from: route)
                
                /// 첫 번째 trafast의 highWayInfo를 업데이트한 새로운 Trafast 생성
                let updatedTrafast = route.trafast.enumerated().map { index, trafast in
                    if index == 0 {
                        return trafast.updatedHighWayInfo(highwayPaths)
                    } else {
                        return trafast
                    }
                }
                /// 새로운 Route 객체 생성
                let updatedRoute = Route(trafast: updatedTrafast)
                return updatedRoute
            }
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
extension LocationInfoUseCase {
    private func extractHighwayPaths(from route: Route) -> [String: [[[Double]]]] {
        var highwayPaths: [String: [[[Double]]]] = [:]
        
        for section in route.trafast.first?.section ?? [] {
            let startIndex = section.pointIndex
            let endIndex = section.pointIndex + section.pointCount

            let sectionPaths = Array(route.trafast.first?.path[startIndex..<endIndex] ?? [])
            
            // 고속도로 경로가 [Double] 배열로 되어 있으므로 이를 [[[Double]]] 형식으로 중첩 배열로 변환
            if let existingPaths = highwayPaths[section.name] {
                highwayPaths[section.name]?.append(sectionPaths)
            } else {
                highwayPaths[section.name] = [sectionPaths]
            }
        }
        return highwayPaths
    }
}

