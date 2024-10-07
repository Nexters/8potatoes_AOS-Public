//
//  LocationModel.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/21/24.
//

import Foundation

// MARK: - 좌표 정보

struct Coordinate: Equatable {
    let lat: Double
    let lon: Double
}

// MARK: - 경로 정보

struct Route {
    let trafast: [Trafast]
}
extension Route {
    struct Trafast {
        let summary: Summary
        let path: [[Double]]
        let section: [Section]
        let guide: [Guide]
        let highWayInfos: [String: [[[Double]]]]
    }

    struct Summary {
        let start: Location
        let goal: Goal
        let distance: Int
        let duration: Int
        let bbox: [[Double]]
        let tollFare: Int
        let taxiFare: Int
        let fuelPrice: Int
    }

    struct Location {
        let location: [Double]
    }

    struct Goal {
        let location: [Double]
        let dir: Int
    }

    struct Section {
        let pointIndex: Int
        let pointCount: Int
        let distance: Int
        let name: String
        let congestion: Int
        let speed: Int
    }

    struct Guide {
        let pointIndex: Int
        let type: Int
        let instructions: String
        let distance: Int
        let duration: Int
    }
}
extension Route.Trafast {
    func updatedHighWayInfo(_ newHighWayInfo: [String: [[[Double]]]]) -> Route.Trafast {
        return .init(
            summary: self.summary,
            path: self.path,
            section: self.section,
            guide: self.guide,
            highWayInfos: newHighWayInfo
        )
    }
}
