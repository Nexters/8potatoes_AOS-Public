//
//  SafeAreaDAO.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 9/5/24.
//

import RxSwift

final class SafeAreaDAO: SafeAreaInfoRepository {
    
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
    

}
