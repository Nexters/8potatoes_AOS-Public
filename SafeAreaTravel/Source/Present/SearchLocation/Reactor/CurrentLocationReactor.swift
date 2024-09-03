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

    }
    
    enum Action {
        case backButtonTapped
    }
    
    enum Mutation {
        case presentSearchViewController
    }
    
    // MARK: - Reactor Method

    func mutate(action: CurrentLocationReactor.Action) -> Observable<CurrentLocationReactor.Mutation> {
        switch action {
        case .backButtonTapped:
                .just(.presentSearchViewController)
        }
    }
    
    func reduce(state: CurrentLocationReactor.State, mutation: CurrentLocationReactor.Mutation) -> State {
        var newState = state
        switch mutation {
        case .presentSearchViewController:
            coordinator.dismissSearchViewController()
        }
        return newState
    }
    
}
