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
    private var startLocation: SearchLocationModel
    private var goalLocation: SearchLocationModel
    
    // MARK: - Init

    init(usecase: LocationInfoUseCaseProtocol,
         coordinator: MainMapCoordinator,
         startLocation: SearchLocationModel,
         goalLocation: SearchLocationModel) {
        self.usecase = usecase
        self.coordinator = coordinator
        self.startLocation = startLocation
        self.goalLocation = goalLocation
        log.debug(startLocation, goalLocation)
        self.initialState = State()
    }
    
    // MARK: - State, Action, Mutation

    struct State {
        var locations: [Route] = []
    }
    
    enum Action {
        case fetchData(start: Coordinate, goal: Coordinate)
    }
    
    enum Mutation {
        case setLocations([Route])
    }
    
    // MARK: - Reactor Method

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchData(let start, let goal):
            return usecase.fetchRouteInfo(start: start, goal: goal)
                .asObservable() 
                .map { locations in
                    return Mutation.setLocations([locations])
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLocations(let locations):
            newState.locations = locations
        }
        return newState
    }
}
