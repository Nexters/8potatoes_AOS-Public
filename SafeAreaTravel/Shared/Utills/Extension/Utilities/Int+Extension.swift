//
//  Int+Extension.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 10/13/24.
//

import Foundation

extension Int {
    
    /// 수의 중간값 구하는 함수
    func getMiddleIndices(count: Int) -> [Int] {
        guard count > 0 else { return [] }
        
        if count % 2 == 0 {
            // Even number of rest stops: return two central indices
            return [count / 2 - 1, count / 2]
        } else {
            // Odd number of rest stops: return the central index
            return [count / 2]
        }
    }
}
