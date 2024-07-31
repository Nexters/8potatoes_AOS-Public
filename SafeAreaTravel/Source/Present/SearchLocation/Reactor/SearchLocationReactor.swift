//
//  SearchLocationReactor.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/23/24.
//

import ReactorKit
import RxSwift

final class SearchLocationReactor: Reactor {
    // MARK: - Properties

    var initialState: State
    private let usecase: LocationInfoUseCaseProtocol
    private let coordinator: StartCoordinatorProtocol
    
    // MARK: - Init

    init(usecase: LocationInfoUseCaseProtocol, coordinator: StartCoordinatorProtocol) {
        self.usecase = usecase
        self.coordinator = coordinator
        self.initialState = State()
    }
    
    // MARK: - State & Action

    struct State {
        var location = Coordinate(lat: 0, lon: 0)
        var searchResults: [SearchLocationModel] = []
    }
    
    enum Action {
        case searchLocation(String)
    }
    
    
    enum Mutation {
        case setSearchResults([SearchLocationModel])
    }
}

// MARK: - Mutation & Reduce

extension SearchLocationReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchLocation(let text):
            return usecase.searchLocation(location: text, page: 1)
                .map { Mutation.setSearchResults($0) }
                .asObservable()
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
