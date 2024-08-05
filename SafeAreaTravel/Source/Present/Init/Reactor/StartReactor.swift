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
    
    // MARK: - Properties
    
    var initialState: State
    private let usecase: LocationInfoUseCaseProtocol
    private let coordinator: StartCoordinatorProtocol
    private var disposeBag = DisposeBag()
    
    // MARK: - Init

    init(usecase: LocationInfoUseCaseProtocol, coordinator: StartCoordinatorProtocol) {
        self.usecase = usecase
        self.coordinator = coordinator
        self.initialState = State()
    }

    // MARK: - State, Action, Mutation

    struct State {
        var startLocation = SearchLocationModel(frontLat: 0.0, frontLon: 0.0, name: "", fullAddressRoad: "", fullAddressNum: "")
        var goalLocation = SearchLocationModel(frontLat: 0.0, frontLon: 0.0, name: "", fullAddressRoad: "", fullAddressNum: "")
        var selectedLocation = SearchLocationModel(frontLat: 0.0, frontLon: 0.0, name: "", fullAddressRoad: "", fullAddressNum: "")
        var isStartLocationTapped: Bool = false
        var isGoalLocationTapped: Bool = false
        var completeSetLocation: Bool = false
    }

    enum Action {
        case startLocationTapped
        case goalLocationTapped
        case chageBtnTapped
        case setSelectedLocation(SearchLocationModel)
        case searchBtnTapped
    }

    enum Mutation {
        case setSelectedLocation(SearchLocationModel)
        case setStartLocationTapped
        case setGoalLocationTapped
        case setStartLocation(SearchLocationModel)
        case setGoalLocation(SearchLocationModel)
        case swapLocation
        case setCompleteSetLocation(Bool)
    }
    
    // MARK: - Reactor Method

    func mutate(action: StartReactor.Action) -> Observable<StartReactor.Mutation> {
        switch action {
        case .startLocationTapped:
            return .just(.setStartLocationTapped)
        case .goalLocationTapped:
            return .just(.setGoalLocationTapped)
        case .chageBtnTapped:
            return .just(.swapLocation).concat(checkCompleteSetLocation())
        case .setSelectedLocation(let location):
            return updateLocation(location: location)
        case .searchBtnTapped:
            return .empty()
        }
    }

    func reduce(state: StartReactor.State, mutation: StartReactor.Mutation) -> State {
        var newState = state
        switch mutation {
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
        case .setStartLocation(let location):
            newState.startLocation = location
        case .setGoalLocation(let location):
            newState.goalLocation = location
        case .swapLocation:
            let temp = newState.startLocation
            newState.startLocation = newState.goalLocation
            newState.goalLocation = temp
        case .setCompleteSetLocation(let isComplete):
            newState.completeSetLocation = isComplete
        }
        newState.completeSetLocation = newState.startLocation.name != "" && newState.goalLocation.name != ""
        return newState
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let selectedLocationState = usecase.event
            .map { event -> Mutation in
                switch event {
                case .selectLocation(let location):
                    log.debug("Transform - selectLocation: \(location)")
                    if self.currentState.isStartLocationTapped {
                        return .setStartLocation(location)
                    } else {
                        return .setGoalLocation(location)
                    }
                }
            }
        return Observable.merge(mutation, selectedLocationState)
    }
}

    // MARK: - Private Method

extension StartReactor {
    
    private func updateLocation(location: SearchLocationModel) -> Observable<Mutation> {
        if currentState.isStartLocationTapped {
            return Observable.just(.setStartLocation(location)).concat(checkCompleteSetLocation())
        } else if currentState.isGoalLocationTapped {
            return Observable.just(.setGoalLocation(location)).concat(checkCompleteSetLocation())
        }
        return Observable.just(.setSelectedLocation(location)).concat(checkCompleteSetLocation())
    }
    
    private func checkCompleteSetLocation() -> Observable<Mutation> {
        let isComplete = currentState.startLocation.name != "" && currentState.goalLocation.name != ""
        return Observable.just(.setCompleteSetLocation(isComplete))
    }
    
    private func getSearchReactor() -> SearchLocationReactor {
        return SearchLocationReactor(usecase: usecase, coordinator: coordinator)
    }
}
