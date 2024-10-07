//
//  LocationInfoUseCase.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import Foundation

import RxSwift

enum LocationEvent {
    case selectLocation(SearchLocationModel)
}

protocol LocationInfoUseCaseProtocol {
    func fetchRouteInfo(start: Coordinate, goal: Coordinate) -> Single<Route>
    func searchLocation(location: String, page: Int) -> Single<[SearchLocationModel]>
    func searchLocationToCoordinate(lat: Double, lon: Double) -> Single<SearchLocationModel>
    var event: PublishSubject<LocationEvent> { get }
    func selectLocation(location: SearchLocationModel) -> Observable<SearchLocationModel>
}

final class LocationInfoUseCase: LocationInfoUseCaseProtocol {
    
    func selectLocation(location: SearchLocationModel) -> RxSwift.Observable<SearchLocationModel> {
        log.debug("LocationInfoUseCase - selectLocation: \(location)")
        event.onNext(.selectLocation(location))
        return .just(location)
    }
    
    let event = PublishSubject<LocationEvent>()
    private let repository: LocationInfoRepository
    
    init(repository: LocationInfoRepository) {
        self.repository = repository
    }
    
    func fetchRouteInfo(start: Coordinate, goal: Coordinate) -> Single<Route> {
        return repository.fetchRouteInfo(start: start, goal: goal)
            .map { route in
                /// 고속도로 경로 추출
                let highwayPaths = self.extractHighwaySections(from: route)
                
                /// 첫 번째 trafast의 highWayInfo를 업데이트한 새로운 Trafast 생성
                let updatedTrafast = route.trafast.enumerated().map { index, trafast in
                    if index == 0 {
                        return trafast.updatedHighWayInfo(highwayPaths)
                    } else {
                        return trafast
                    }
                }
                /// 새로운 Route 객체 생성
                let updatedRoute = Route(trafast: updatedTrafast)
                return updatedRoute
            }
    }
    
    func searchLocation(location: String, page: Int) -> Single<[SearchLocationModel]> {
        return repository.searchLocation(location: location, page: page)
            .map { models in
                return models.map { $0.cleaned() }
            }
    }
    
    func searchLocationToCoordinate(lat: Double, lon: Double) -> RxSwift.Single<SearchLocationModel> {
        return repository.searchLocationToCoordinate(lat: lat, lon: lon)
    }
}
extension LocationInfoUseCase {
    func extractHighwaySections(from route: Route) -> [String: [[[Double]]]] {
        var highwaySections: [String: [[[Double]]]] = [:]
        guard let trafast = route.trafast.first else { return highwaySections }
        
        let path = trafast.path
        let guides = trafast.guide
        
        var currentHighwayName: String?
        var currentHighwayStartIndex: Int?
        
        // 고속도로 진입과 출구를 나타내는 type 값의 집합 정의
        let highwayEntranceTypes: Set<Int> = [50, 57, 66]
        let highwayExitTypes: Set<Int> = [51, 58, 67]
        
        for guide in guides {
            let instruction = guide.instructions
            let pointIndex = guide.pointIndex
            let type = guide.type
            
            // 고속도로 진입 여부 확인
            if let highwayName = extractHighwayName(from: instruction, type: type, highwayEntranceTypes: highwayEntranceTypes) {
                // 새로운 고속도로 진입
                currentHighwayName = highwayName
                currentHighwayStartIndex = pointIndex
            }
            // 고속도로 출구 여부 확인
            else if isHighwayExitGuide(type: type, highwayExitTypes: highwayExitTypes) {
                if let highwayName = currentHighwayName, let startIndex = currentHighwayStartIndex {
                    let endIndex = pointIndex
                    if startIndex >= 0 && endIndex < path.count && startIndex <= endIndex {
                        let highwaySectionPath = Array(path[startIndex...endIndex])
                        
                        // 섹션을 여러 개의 쿼드로 변환
                        let quads = convertSectionToQuads(highwaySectionPath, segmentLength: 10)
                        
                        // 딕셔너리 업데이트
                        highwaySections[highwayName, default: []].append(contentsOf: quads)
                    }
                    // 고속도로 종료
                    currentHighwayName = nil
                    currentHighwayStartIndex = nil
                }
            }
        }
        
        return highwaySections
    }
    
    private func extractHighwayName(from instruction: String, type: Int, highwayEntranceTypes: Set<Int>) -> String? {
        if highwayEntranceTypes.contains(type) {
            // "경부고속도로" 등의 고속도로 이름 추출
            let pattern = "['\"]?([가-힣]+고속도로)['\"]?"
            if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                let range = NSRange(instruction.startIndex..., in: instruction)
                if let match = regex.firstMatch(in: instruction, options: [], range: range) {
                    if let range = Range(match.range(at: 1), in: instruction) {
                        return instruction[range].trimmingCharacters(in: .whitespaces)
                    }
                }
            }
        }
        return nil
    }
    
    private func isHighwayExitGuide(type: Int, highwayExitTypes: Set<Int>) -> Bool {
        return highwayExitTypes.contains(type)
    }
    
    private func convertSectionToQuads(_ path: [[Double]], segmentLength: Int = 10) -> [[[Double]]] {
        var quads: [[[Double]]] = []
        let totalPoints = path.count

        // 분할된 구간의 시작 인덱스를 생성
        let indices = stride(from: 0, to: totalPoints, by: segmentLength)
        for startIndex in indices {
            let endIndex = min(startIndex + segmentLength - 1, totalPoints - 1)
            let segment = Array(path[startIndex...endIndex])

            // 각 구간에 대해 쿼드 생성
            if let quad = createQuad(for: segment) {
                quads.append(quad)
            }
        }

        return quads
    }

    private func createQuad(for segment: [[Double]]) -> [[Double]]? {
        guard segment.count >= 2 else { return nil }

        // 구간의 좌표에서 위도와 경도의 최소값과 최대값을 구합니다.
        let latitudes = segment.map { $0[1] }
        let longitudes = segment.map { $0[0] }

        guard let minLat = latitudes.min(),
              let maxLat = latitudes.max(),
              let minLon = longitudes.min(),
              let maxLon = longitudes.max() else {
            return nil
        }

        // 사각형의 네 꼭지점을 정의합니다.
        let quad = [
            [minLon, maxLat], // 좌상단
            [maxLon, maxLat], // 우상단
            [maxLon, minLat], // 우하단
            [minLon, minLat]  // 좌하단
        ]

        return quad
    }
}



