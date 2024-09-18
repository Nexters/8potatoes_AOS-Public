//
//  RequestRoute.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 9/17/24.
//

import Foundation

struct RequestRoute: Encodable {
    let highways: [String: [[[Double]]]]
}
