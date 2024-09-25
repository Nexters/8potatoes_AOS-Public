//
//  SafeAreaDAO.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 9/5/24.
//

import RxSwift
import Foundation

final class SafeAreaDAO: SafeAreaInfoRepository {
    
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
    
    func fetchSafeAreaList(start: Coordinate, goal: Coordinate, route: Route) -> Single<SafeAreaListInfo> {
        let startCoord = "\(start.lat),\(start.lon)"
        let goalCoord = "\(goal.lat),\(goal.lon)"
        return network
            .request(.fetchSafeAreaList(start: "37.5431112,126.9821125", goal: "35.5597367,127.8157298", highWayInfo: route.trafast[0].highWayInfo))
            .map { response -> SafeAreaDTO in
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode([SafeAreaDTO].self, from: response.data) // 배열로 디코딩
                    if let firstSafeArea = decodedResponse.first {
                        return firstSafeArea
                    } else {
                        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "No SafeAreaDTO found"))
                    }
                } catch {
                    log.error("Decoding error: \(error)")
                    if let jsonString = String(data: response.data, encoding: .utf8) {
                        log.error("Received JSON: \(jsonString)")
                    }
                    throw error
                }
            }
            .map { $0.toDomain() }
            .do(onSuccess: { (route) in
                log.debug("response fetchSafeAreaList \(route)")
            }, onError: { error in
                log.error("Error occurred during fetchSafeAreaList request: \(error.localizedDescription)")
            })
    }
    
    func fetchSafeAreaDetailInfo(code: String) -> Single<DetailSafeArea> {
        return network
            .request(.fetchSafeAreaInfo(code: code))
            .flatMap { response -> Single<DetailSafeAreaDTO> in
                if let detailSafeAreaDTO = try? self.network.decodeJSON(from: response.data, to: DetailSafeAreaDTO.self) {
                    return .just(detailSafeAreaDTO)
                } else {
                    let decodingError = NSError(domain: "DecodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode DetailSafeAreaDTO"])
                    return .error(decodingError)
                }
            }
            .map { $0.toDomain() }
            .do(onSuccess: { (location) in
                log.debug("response DetailSafeAreaDTO")
            }, onError: { error in
                log.error("Error occurred during fetchSafeAreaDetailInfo request DAO: \(error.localizedDescription)")
            })
    }
}
