//
//  DetailRestAreaReactor.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import ReactorKit
import RxSwift
import RxCocoa

final class DetailRestAreaReactor: Reactor {
    
    // MARK: - Properties

    var initialState: State
    private let usecase: SafeAreaInfoUseCaseProtocol
    private let coordinator: DetailRestAreaCoordinatorProtocol
    private let code: String

    // MARK: - Init

    init(usecase: SafeAreaInfoUseCaseProtocol,
         coordinator: DetailRestAreaCoordinatorProtocol,
         code: String) {
        self.usecase = usecase
        self.coordinator = coordinator
        self.code = code
        self.initialState = State()
    }
    
    // MARK: - State, Action, Mutation

    struct State {
        var info: DetailSafeArea?
        var isLoading: Bool = false
        var error: Error?
    }
    
    enum Action {
        case viewDidLoad
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setDetailInfo(DetailSafeArea)
        case setError(Error)
    }
    
    // MARK: - Reactor Method

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                usecase.fetchSafeAreaDetailInfo(code: code)
                    .asObservable()
                    .map { Mutation.setDetailInfo($0) }
                    .catch { .just(Mutation.setError($0)) },
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
   func reduce(state: State, mutation: Mutation) -> State {
       var newState = state
       
       switch mutation {
       case .setLoading(let isLoading):
           newState.isLoading = isLoading
           
       case .setDetailInfo(let detailInfo):
          
           newState.info = makeStringInfo(info: detailInfo)
           newState.error = nil
           
       case .setError(let error):
           newState.error = error
           newState.info = nil
       }
       return newState
   }
}

//MARK: - PrivateMethod

extension DetailRestAreaReactor {
   private func makeStringInfo(info: DetailSafeArea) -> DetailSafeArea {
      let openInfo = info.isOperating == true ? "식당 영업중" :  "식당 영업종료"
      let direction = "| \(info.direction)방향"
      let safeAreaInfo = "\(openInfo)·\(info.endTime)까지 ★\(info.naverRating)·네이버평점"
      var result = info
      result.openInfo = openInfo
      result.safeAreaInfo = safeAreaInfo
      result.direction = direction
      return result
   }
}
