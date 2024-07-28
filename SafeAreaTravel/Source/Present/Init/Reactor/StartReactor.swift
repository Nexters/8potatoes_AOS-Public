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
        case startLocationTapped
        case goalLocationTapped
    }
    
    enum Mutation {
        case none
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startLocationTapped:
            coordinator.presentSearchViewController()

            return .just(.none)
        case .goalLocationTapped:
            coordinator.presentSearchViewController()
            return .just(.none)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        return newState
    }
}
