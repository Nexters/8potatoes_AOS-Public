//
//  RouteResponseDTO+Mapping.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/21/24.
//

import Foundation

// MARK: - RouteDTO

struct RouteResponseDTO: ModelType {
    let code: Int
    let message: String
    let currentDateTime: String
    let route: RouteDTO
}
extension RouteResponseDTO {
    struct RouteDTO: ModelType {
        let traoptimal: [TrafastDTO]?
    }
}

extension RouteResponseDTO.RouteDTO {
    struct TrafastDTO: ModelType {
        let summary: SummaryDTO
        let path: [[Double]]
        let section: [SectionDTO]
        let guide: [GuideDTO]
    }
}
extension RouteResponseDTO.RouteDTO.TrafastDTO {
    struct SummaryDTO: ModelType {
        let start: LocationDTO
        let goal: GoalDTO
        let distance: Int
        let duration: Int
        let bbox: [[Double]]
        let tollFare: Int
        let taxiFare: Int
        let fuelPrice: Int
    }

    struct LocationDTO: ModelType {
        let location: [Double]
    }

    struct GoalDTO: ModelType {
        let location: [Double]
        let dir: Int
    }

    struct SectionDTO: ModelType {
        let pointIndex: Int
        let pointCount: Int
        let distance: Int
        let name: String
        let congestion: Int
        let speed: Int
    }

    struct GuideDTO: ModelType {
        let pointIndex: Int
        let type: Int
        let instructions: String
        let distance: Int
        let duration: Int
    }
}

// MARK: - Mappings to Domain

extension RouteResponseDTO {
    func toDomain() -> Route {
        return .init(trafast: route.traoptimal?.map { $0.toDomain() } ?? [])
    }
}

extension RouteResponseDTO.RouteDTO {
    func toDomain() -> Route {
        return .init(trafast: traoptimal?.map { $0.toDomain() } ?? [])
    }
}

extension RouteResponseDTO.RouteDTO.TrafastDTO {
    func toDomain() -> Route.Trafast {
        return .init(
            summary: summary.toDomain(),
            path: path,
            section: section.map { $0.toDomain() },
            guide: guide.map { $0.toDomain() },
            highWayInfos: [:]
        )
    }
}

extension RouteResponseDTO.RouteDTO.TrafastDTO.SummaryDTO {
    func toDomain() -> Route.Summary {
        return .init(
            start: start.toDomain(),
            goal: goal.toDomain(),
            distance: distance,
            duration: duration,
            bbox: bbox,
            tollFare: tollFare,
            taxiFare: taxiFare,
            fuelPrice: fuelPrice
        )
    }
}

extension RouteResponseDTO.RouteDTO.TrafastDTO.LocationDTO {
    func toDomain() -> Route.Location {
        return .init(location: location)
    }
}

extension RouteResponseDTO.RouteDTO.TrafastDTO.GoalDTO {
    func toDomain() -> Route.Goal {
        return .init(location: location, dir: dir)
    }
}

extension RouteResponseDTO.RouteDTO.TrafastDTO.SectionDTO {
    func toDomain() -> Route.Section {
        return .init(
            pointIndex: pointIndex,
            pointCount: pointCount,
            distance: distance,
            name: name,
            congestion: congestion,
            speed: speed
        )
    }
}

extension RouteResponseDTO.RouteDTO.TrafastDTO.GuideDTO {
    func toDomain() -> Route.Guide {
        return .init(
            pointIndex: pointIndex,
            type: type,
            instructions: instructions,
            distance: distance,
            duration: duration
        )
    }
}
