//
//  StartReactor.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/28/24.
//

import ReactorKit
import RxSwift
import RxCocoa

final class StartReactor: DetectDeinit, Reactor {
    
    var initialState: State
    private let usecase: LocationInfoUseCaseProtocol
    private let coordinator: StartCoordinator
    
    init(usecase: LocationInfoUseCaseProtocol, coordinator: StartCoordinator) {
        self.usecase = usecase
        self.coordinator = coordinator
        self.initialState = State()
    }
    
    struct State {
        var startLocation = Coordinate(lat: 0, lon: 0)
    }
    
    enum Action {
        case fetchData(start: Coordinate, goal: Coordinate)
    }
    
    enum Mutation {
        case setLocations([Route])
    }
       
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchData(let start, let goal):
            return usecase.fetchRouteInfo(start: start, goal: goal)
                .asObservable() // Single을 Observable로 변환
                .map { locations in
                    return Mutation.setLocations([locations])
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
//        switch mutation {
//        case .setLocations(let locations):
//            newState.startLocation = 0
//        }
        return newState
    }
}
