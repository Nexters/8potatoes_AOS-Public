//
//  LocationModel.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/21/24.
//

import Foundation

// MARK: - 좌표 정보
struct Coordinate {
    let lat: Double
    let lon: Double
}

// MARK: - 경로 정보
struct Route: Codable {
    let trafast: [Trafast]
}
extension Route {
    struct Trafast: Codable {
        let summary: Summary
        let path: [[Double]]
        let section: [Section]
        let guide: [Guide]
    }

    struct Summary: Codable {
        let start: Location
        let goal: Goal
        let distance: Int
        let duration: Int
        let bbox: [[Double]]
        let tollFare: Int
        let taxiFare: Int
        let fuelPrice: Int
    }

    struct Location: Codable {
        let location: [Double]
    }

    struct Goal: Codable {
        let location: [Double]
        let dir: Int
    }

    struct Section: Codable {
        let pointIndex: Int
        let pointCount: Int
        let distance: Int
        let name: String
        let congestion: Int
        let speed: Int
    }

    struct Guide: Codable {
        let pointIndex: Int
        let type: Int
        let instructions: String
        let distance: Int
        let duration: Int
    }
}
