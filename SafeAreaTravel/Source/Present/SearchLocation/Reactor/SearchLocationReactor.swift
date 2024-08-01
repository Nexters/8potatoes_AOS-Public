//
//  SearchLocationReactor.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/23/24.
//

import ReactorKit
import RxSwift

final class SearchLocationReactor: Reactor {
    
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
        var searchResults: [SearchLocationModel] = []
    }
    
    enum Action {
        case searchLocation(String)
        case selectLocation(SearchLocationModel)
    }
    
    enum Mutation {
        case setSearchResults([SearchLocationModel])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchLocation(let text):
            return usecase.searchLocation(location: text, page: 1)
                .map { Mutation.setSearchResults($0) }
                .asObservable()
        case .selectLocation(let location):
            usecase.selectLocation(location: location)
            coordinator.dismissSearchViewController()
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSearchResults(let results):
            newState.searchResults = results
        }
        return newState
    }
}
