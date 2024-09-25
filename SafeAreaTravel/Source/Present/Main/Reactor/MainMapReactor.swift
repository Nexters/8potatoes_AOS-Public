//
//  MainMapReactor.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import ReactorKit
import RxSwift
import RxCocoa

final class MainMapReactor: Reactor {
    
    // MARK: - Properties

    var initialState: State
    private let usecase: SafeAreaInfoUseCaseProtocol
    private let coordinator: MainMapCoordinatorProtocol
    
    // MARK: - Init

    init(usecase: SafeAreaInfoUseCaseProtocol,
         coordinator: MainMapCoordinatorProtocol,
         startLocation: SearchLocationModel,
         goalLocation: SearchLocationModel,
         route: Route) {
        self.usecase = usecase
        self.coordinator = coordinator
        self.initialState = State(route: route,
                                  startLocation: startLocation,
                                  goalLocation: goalLocation)
    }
    
    // MARK: - State, Action, Mutation

    struct State {
        var route: Route
        var startLocation: SearchLocationModel
        var goalLocation: SearchLocationModel
        var safeAreaList: SafeAreaListInfo = SafeAreaListInfo(totalReststopCount: 0,
                                                              reststops: [])
    }
    
    enum Action {
        case viewDidLoad
        case changeStartLocation
        case changeGoalLocation
        case safeAreaListTapped(String)
    }
    
    enum Mutation {
        case setRoute(Route)
        case setSafeAreaList(SafeAreaListInfo)
    }
    
    // MARK: - Reactor Method

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let startCoord = Coordinate(lat: currentState.startLocation.frontLat,
                                        lon: currentState.startLocation.frontLon)
            let goalCoord = Coordinate(lat: currentState.goalLocation.frontLat,
                                        lon: currentState.goalLocation.frontLon)
            return usecase
                .fetchSafeAreaList(start: startCoord, goal: goalCoord, route: currentState.route)
                .asObservable()
                .map {Mutation.setSafeAreaList($0)}
        case .changeStartLocation:
            return .empty()
        case .changeGoalLocation:
            return .empty()
        case .safeAreaListTapped(let code):
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setRoute(let locations):
            newState.route = locations
        case .setSafeAreaList(let safeAreas):
            newState.safeAreaList = safeAreas
        }
        return newState
    }
}
