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
    private var disposeBag = DisposeBag()
    
    init(usecase: LocationInfoUseCaseProtocol, coordinator: StartCoordinatorProtocol) {
        self.usecase = usecase
        self.coordinator = coordinator
        self.initialState = State()
    }

    struct State {
        var startLocation = Coordinate(lat: 0, lon: 0)
        var selectedLocation = SearchLocationModel(frontLat: 0.0, frontLon: 0.0, name: "", fullAddressRoad: "", fullAddressNum: "")
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

    func mutate(action: StartReactor.Action) -> Observable<StartReactor.Mutation> {
        log.debug("Mutate - action: \(action)")
        switch action {
        case .startLocationTapped:
            return .just(.setStartLocationTapped)
        case .goalLocationTapped:
            return .just(.setGoalLocationTapped)
        case .chageBtnTapped:
            return .just(.none)
        case .setSelectedLocation(let location):
            return .just(.setSelectedLocation(location))
        }
    }

    func reduce(state: StartReactor.State, mutation: StartReactor.Mutation) -> State {
        var newState = state
        log.debug("Reduce - mutation: \(mutation)")
        switch mutation {
        case .none:
            break
        case .setSelectedLocation(let location):
            newState.selectedLocation = location
        case .setStartLocationTapped:
            newState.isStartLocationTapped = true
            newState.isGoalLocationTapped = false
            coordinator.presentSearchViewController(reactor: getSearchReactor())
        case .setGoalLocationTapped:
            newState.isStartLocationTapped = false
            newState.isGoalLocationTapped = true
            coordinator.presentSearchViewController(reactor: getSearchReactor())
        }
        return newState
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        log.debug("transform - Mutation: \(mutation)")

        let selectedLocationState = usecase.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case .selectLocation(let location):
                    log.debug("Transform - selectLocation: \(location)")
                    var newState = self.currentState
                    newState.selectedLocation = location
                    return .just(.setStartLocationTapped)
                }
            }
        return Observable.merge(mutation, selectedLocationState)
    }
}
extension StartReactor {
    func getSearchReactor() -> SearchLocationReactor {
        return SearchLocationReactor(usecase: usecase, coordinator: coordinator)
    }
}
