//
//  SafeAreaInfoUseCase.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 9/5/24.
//

import RxSwift

protocol SafeAreaInfoUseCaseProtocol {
    func fetchSafeAreaList(start: Coordinate, goal: Coordinate, route: Route) -> Single<SafeAreaListInfo>
    func fetchSafeAreaDetailInfo(code: String) -> Single<DetailSafeArea>
}
final class SafeAreaInfoUseCase: SafeAreaInfoUseCaseProtocol {
    
    private let repository: SafeAreaInfoRepository
    
    init(repository: SafeAreaInfoRepository) {
        self.repository = repository
    }
    
    func fetchSafeAreaList(start: Coordinate, goal: Coordinate, route: Route) -> RxSwift.Single<SafeAreaListInfo> {
        return repository.fetchSafeAreaList(start: start, goal: goal, route: route)
    }
    
    func fetchSafeAreaDetailInfo(code: String) -> RxSwift.Single<DetailSafeArea> {
        return repository.fetchSafeAreaDetailInfo(code: code)
    }
}
