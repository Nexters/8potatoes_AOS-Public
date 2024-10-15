//
//  DetectDeinit.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import Foundation

class DetectDeinit: NSObject {
    
    lazy private(set) var className: String = {
      return type(of: self).description().components(separatedBy: ".").last ?? ""
}()
    
    deinit {
      log.verbose("DEINIT: \(self.className)")
    }
}
