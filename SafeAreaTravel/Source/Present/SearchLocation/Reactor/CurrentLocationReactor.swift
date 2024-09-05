//
//  CurrentLocationReactor.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 8/22/24.
//

import ReactorKit
import RxSwift

final class CurrentLocationReactor: Reactor {
    
    // MARK: - Properties
    
    let initialState: State
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
        var location = SearchLocationModel(frontLat: 0.0, frontLon: 0.0, name: "", fullAddressRoad: "", fullAddressNum: "")
    }
    
    enum Action {
        case backButtonTapped
        case viewDidLoad(Double, Double)
        case setLocationTapped
    }
    
    enum Mutation {
        case presentSearchViewController
        case setCurrentLocation(SearchLocationModel)
    }
    
    // MARK: - Reactor Method

    func mutate(action: CurrentLocationReactor.Action) -> Observable<CurrentLocationReactor.Mutation> {
        switch action {
        case .backButtonTapped:
             return .just(.presentSearchViewController)
        case .viewDidLoad(let lat, let lng):
            return usecase.searchLocationToCoordinate(lat: lat, lon: lng)
                .map { model in
                    return .setCurrentLocation(SearchLocationModel(frontLat: model.frontLat,
                                                                   frontLon: model.frontLon,
                                                                   name: model.name,
                                                                   fullAddressRoad: model.lastAddressRoad,
                                                                   fullAddressNum: model.fullAddressNum))
                }
                .asObservable()
        case .setLocationTapped:
            let currentLocation = self.currentState.location
            usecase.selectLocation(location: currentLocation)
                .subscribe(onNext: { res in
                    self.coordinator.dismissSearchViewController()
                })
                .disposed(by: disposeBag)
            return .empty()
        }
    }
    
    func reduce(state: CurrentLocationReactor.State, mutation: CurrentLocationReactor.Mutation) -> State {
        var newState = state
        switch mutation {
        case .presentSearchViewController:
            coordinator.dismissOnlyTopViewController()
        case .setCurrentLocation(let result):
            newState.location = result
        }
        return newState
    }
    
}
