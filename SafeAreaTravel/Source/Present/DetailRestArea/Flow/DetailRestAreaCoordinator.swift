//
//  DetailRestAreaCoordinator.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 9/16/24.
//

import UIKit

protocol DetailRestAreaDependencies {
    
}

protocol DetailRestAreaCoordinatorProtocol {
    
}

final class DetailRestAreaCoordinator: DetailRestAreaCoordinatorProtocol {
    
    private let navigationController: UINavigationController
    private let dependencies: DetailRestAreaDependencies
    
    init(navigationController: UINavigationController,
         dependencies: DetailRestAreaDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        
    }
}
