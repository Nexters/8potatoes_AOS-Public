//
//  SafeAreaInfoRepository.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 9/5/24.
//

import RxSwift

protocol SafeAreaInfoRepository {
    func fetchSafeAreaList(start: Coordinate, goal: Coordinate, route: Route) -> Single<SafeAreaListInfo>
    func fetchSafeAreaDetailInfo(code: String) -> Single<DetailSafeArea>
}
