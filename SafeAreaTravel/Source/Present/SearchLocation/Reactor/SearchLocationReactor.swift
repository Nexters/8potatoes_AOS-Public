//
//  SearchLocationReactor.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/23/24.
//

import ReactorKit
import RxSwift

final class SearchLocationReactor {
    var initialState: State
    private let usecase: LocationInfoUseCaseProtocol
    private let coordinator: StartCoordinatorProtocol
    
    init(usecase: LocationInfoUseCaseProtocol, coordinator: StartCoordinatorProtocol) {
        self.usecase = usecase
        self.coordinator = coordinator
        self.initialState = State()
    }
    
    struct State {
        var location = Coordinate(lat: 0, lon: 0)
        var searchText: String = ""
    }
    
    enum Action {
        case searchLocation(String)
        case xMarkBtnTapped
    }
    
    enum Mutation {
        case none
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {

        case .searchLocation(_):
            break
        case .xMarkBtnTapped:
            break
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        return newState
    }
}
