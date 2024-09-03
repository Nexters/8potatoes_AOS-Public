//
//  GlobalStateManger.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 8/25/24.
//

import RxSwift

final class GlobalStateManager {
    /// 싱글톤 인스턴스
    static let shared = GlobalStateManager()
    
    /// 전역 상태로 관리할 출발지와 목적지
    private let startLocationSubject = BehaviorSubject<SearchLocationModel?>(value: nil)
    private let goalLocationSubject = BehaviorSubject<SearchLocationModel?>(value: nil)
    
    /// 외부에서 접근 가능한 Observable
    var startLocation: Observable<SearchLocationModel?> {
        return startLocationSubject.asObservable()
    }
    
    var goalLocation: Observable<SearchLocationModel?> {
        return goalLocationSubject.asObservable()
    }
    
    private init() {}
    
    /// 출발지 업데이트 함수
    func updateStartLocation(_ location: SearchLocationModel) {
        startLocationSubject.onNext(location)
    }
    
    /// 목적지 업데이트 함수
    func updateGoalLocation(_ location: SearchLocationModel) {
        goalLocationSubject.onNext(location)
    }
    
    /// 출발지 초기화 함수
    func resetStartLocation() {
        startLocationSubject.onNext(nil)
    }
    
    /// 목적지 초기화 함수
    func resetGoalLocation() {
        goalLocationSubject.onNext(nil)
    }
}
