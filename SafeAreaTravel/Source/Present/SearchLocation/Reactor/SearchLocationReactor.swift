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
        var searchResults: [SearchLocationModel] = []
    }
    
    enum Action {
        case searchLocation(String)
        case selectLocation(SearchLocationModel)
        case currentLocationTapped
        case dismissTapped
    }
    
    enum Mutation {
        case setSearchResults([SearchLocationModel])
        case selectedLocation(SearchLocationModel)
        case setCurrentLocationTapped
        case setDismissViewController
    }
    
    // MARK: - Reactor Method

    func mutate(action: SearchLocationReactor.Action) -> Observable<SearchLocationReactor.Mutation> {
        switch action {
        case .searchLocation(let text):
            return usecase.searchLocation(location: text, page: 1)
                .map { Mutation.setSearchResults($0) }
                .asObservable()
        case .selectLocation(let location):
            usecase.selectLocation(location: location)
                .subscribe(onNext: { res in
                    self.coordinator.dismissSearchViewController()
                })
                .disposed(by: disposeBag)
            return .empty()
        case .currentLocationTapped:
            return .just(.setCurrentLocationTapped)
        case .dismissTapped:
            return .just(.setDismissViewController)
        }
    }
    
    func reduce(state: SearchLocationReactor.State, mutation: SearchLocationReactor.Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSearchResults(let results):
            newState.searchResults = results
        case .selectedLocation(let location):
            newState.location = location
        case .setCurrentLocationTapped:
            coordinator.pushCurrentLocationViewController(reactor: getCurrentSearchReactor())
        case .setDismissViewController:
            coordinator.dismissSearchViewController()
        }
        return newState
    }
}

// MARK: - Private Method

extension SearchLocationReactor {
    private func getCurrentSearchReactor() -> CurrentLocationReactor {
        return CurrentLocationReactor(usecase: usecase, coordinator: coordinator)
    }
}
