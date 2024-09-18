//
//  Encodable+Extension.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 9/17/24.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any]
    }
}
