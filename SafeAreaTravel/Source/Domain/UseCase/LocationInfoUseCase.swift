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
                /// '고속도로' 키에 해당하는 값이 있는지 확인하고 쿼드 리스트를 추출
                if let highwaySections = highwayPaths["고속도로"] {
                    let quads = highwaySections.map { $0.1 } // 각 튜플에서 쿼드([[Double]])만 추출
                    let highwayInfo = ["고속도로" : quads]
                    /// 첫 번째 trafast의 highWayInfo를 업데이트한 새로운 Trafast 생성
                    let updatedTrafast = route.trafast.enumerated().map { index, trafast in
                        if index == 0 {
                            return trafast.updatedHighWayInfo(highwayInfo)
                        } else {
                            return trafast
                        }
                    }
                    /// 새로운 Route 객체 생성
                    let updatedRoute = Route(trafast: updatedTrafast)
                    return updatedRoute
                } else {
                    /// highwayPaths에 '고속도로' 키가 없을 경우 처리
                    return route
                }
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
    
    /// 고속도로 경로 추출하는 함수 (정사각형의 4개의 좌표배열)
    func extractHighwaySections(from route: Route) -> [String: [([Int], [[Double]])]] {
        var highwaySections: [String: [([Int], [[Double]])]] = [:]
        let highwayKey = "고속도로"

        // Trafast 데이터가 존재하는지 확인
        guard let trafast = route.trafast.first else {
            log.warning("경로에 trafast 데이터가 없습니다.")
            return highwaySections
        }

        let path = trafast.path
        let sections = trafast.section
        let guides = trafast.guide

        // 고속도로 진입 타입 정의 (고속도로 진입에 해당하는 타입만 포함)
        let highwayEntranceTypes: Set<Int> = [50, 52, 54, 57, 59, 66, 68, 75, 76, 77, 121]

        // 첫 번째 고속도로 진입 가이드 찾기
        guard let firstEntranceGuide = guides.first(where: { highwayEntranceTypes.contains($0.type) }) else {
            log.warning("경로에 고속도로 진입 가이드가 없습니다.")
            return highwaySections
        }

        let firstEntrancePointIndex = firstEntranceGuide.pointIndex
        log.debug("첫 번째 고속도로 진입 포인트 인덱스: \(firstEntrancePointIndex), 좌표: \(path[firstEntrancePointIndex])")

        // 모든 섹션을 순회하며 고속도로 섹션 추출
        for section in sections {
            let sectionStartIndex = section.pointIndex
            let sectionEndIndex = section.pointIndex + section.pointCount - 1

            // 섹션이 firstEntrancePointIndex를 포함하는지 확인
            if sectionEndIndex < firstEntrancePointIndex {
                // 섹션이 firstEntrancePointIndex 이전에 끝나면 건너뜀
                continue
            }

            // 섹션의 시작 인덱스 조정
            let startIndex = max(sectionStartIndex, firstEntrancePointIndex)
            let endIndex = sectionEndIndex

            // 유효한 인덱스인지 확인
            if startIndex < 0 || endIndex >= path.count || startIndex > endIndex {
                log.warning("고속도로 섹션의 인덱스가 유효하지 않습니다. StartIndex: \(startIndex), EndIndex: \(endIndex), Path Count: \(path.count)")
                continue
            }

            // 해당 섹션의 경로 추출 (인덱스와 함께)
            let highwaySectionPathWithIndices = Array(zip(startIndex...endIndex, path[startIndex...endIndex]))

            // 섹션을 여러 개의 쿼드로 변환
            let quadsWithIndices = convertSectionToQuadsWithIndices(highwaySectionPathWithIndices, segmentLength: 10)

            // 딕셔너리에 추가 (고속도로 키 사용)
            highwaySections[highwayKey, default: []].append(contentsOf: quadsWithIndices)
            log.info("고속도로 섹션 추가: 포인트 수: \(highwaySectionPathWithIndices.count)")
        }

        return highwaySections
    }
    
    ///섹션을 쿼드로 변환하는 함수 (인덱스 포함)
    private func convertSectionToQuadsWithIndices(_ pathWithIndices: [(Int, [Double])], segmentLength: Int = 10) -> [([Int], [[Double]])] {
        var quadsWithIndices: [([Int], [[Double]])] = []
        let totalPoints = pathWithIndices.count

        // 일정 길이(segmentLength)로 분할하여 쿼드 생성
        let indices = stride(from: 0, to: totalPoints, by: segmentLength)
        for startIndex in indices {
            let endIndex = min(startIndex + segmentLength - 1, totalPoints - 1)
            let segmentWithIndices = Array(pathWithIndices[startIndex...endIndex])

            if let quadWithIndices = createQuadWithIndices(for: segmentWithIndices) {
                quadsWithIndices.append(quadWithIndices)
            }
        }

        return quadsWithIndices
    }

    /// 주어진 구간에서 쿼드를 생성하는 함수 (인덱스 포함)
    private func createQuadWithIndices(for segmentWithIndices: [(Int, [Double])]) -> ([Int], [[Double]])? {
        guard segmentWithIndices.count >= 2 else { return nil }

        let indices = segmentWithIndices.map { $0.0 }
        let points = segmentWithIndices.map { $0.1 }
        let latitudes = points.map { $0[1] }
        let longitudes = points.map { $0[0] }

        guard let minLat = latitudes.min(),
              let maxLat = latitudes.max(),
              let minLon = longitudes.min(),
              let maxLon = longitudes.max() else {
            return nil
        }

        let quad = [
            [minLon, maxLat], // 좌상단
            [maxLon, maxLat], // 우상단
            [maxLon, minLat], // 우하단
            [minLon, minLat]  // 좌하단
        ]

        return (indices, quad)
    }
}
