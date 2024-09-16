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
    private let usecase: LocationInfoUseCaseProtocol
    private let coordinator: MainMapCoordinator
    
    // MARK: - Init

    init(usecase: LocationInfoUseCaseProtocol,
         coordinator: MainMapCoordinator,
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
    }
    
    enum Action {
        case fetchData(locationInfo: String, route: Route)
    }
    
    enum Mutation {
        case setRoute(Route)
    }
    
    // MARK: - Reactor Method

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchData(let locationInfo, let route):
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setRoute(let locations):
            newState.route = locations
        }
        return newState
    }
}
