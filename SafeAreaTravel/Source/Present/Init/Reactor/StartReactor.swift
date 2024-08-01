//
//  StartReactor.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/28/24.
//

import ReactorKit
import RxSwift
import RxCocoa

final class StartReactor: Reactor {
    var initialState: State
    private let usecase: LocationInfoUseCaseProtocol
    private let coordinator: StartCoordinatorProtocol

    init(usecase: LocationInfoUseCaseProtocol, coordinator: StartCoordinatorProtocol) {
        self.usecase = usecase
        self.coordinator = coordinator
        self.initialState = State()
    }

    struct State {
        var startLocation = Coordinate(lat: 0, lon: 0)
        var selectedLocation: SearchLocationModel?
        var isStartLocationTapped: Bool = false
        var isGoalLocationTapped: Bool = false
    }

    enum Action {
        case startLocationTapped
        case goalLocationTapped
        case chageBtnTapped
        case setSelectedLocation(SearchLocationModel)
    }

    enum Mutation {
        case none
        case setSelectedLocation(SearchLocationModel)
        case setStartLocationTapped
        case setGoalLocationTapped
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startLocationTapped:
            coordinator.presentSearchViewController()
            return .just(.setStartLocationTapped)
        case .goalLocationTapped:
            coordinator.presentSearchViewController()
            return .just(.setGoalLocationTapped)
        case .chageBtnTapped:
            return .just(.none)
        case .setSelectedLocation(let location):
            return .just(.setSelectedLocation(location))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .none:
            break
        case .setSelectedLocation(let location):
            newState.selectedLocation = location
        case .setStartLocationTapped:
            newState.isStartLocationTapped = true
            newState.isGoalLocationTapped = false
        case .setGoalLocationTapped:
            newState.isStartLocationTapped = false
            newState.isGoalLocationTapped = true
        }
        return newState
    }

    func transform(action: Observable<Action>) -> Observable<Action> {
        let selectedLocationAction = usecase.event
            .flatMap { event -> Observable<Action> in
                switch event {
                case .selectLocation(let location):
                    return .just(.setSelectedLocation(location))
                }
            }
        return Observable.merge(action, selectedLocationAction)
    }
}

