//
//  MainMapCoordinator.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import UIKit

protocol MainMapCoordinatorDependencies {
    func makeMainMapViewController(coordinator: MainMapCoordinatorProtocol,
                                   startLocation: SearchLocationModel,
                                   goalLocation: SearchLocationModel) -> MainMapViewController
}

protocol MainMapCoordinatorProtocol {
    func start(startLocation: SearchLocationModel, goalLocation: SearchLocationModel)
}

final class MainMapCoordinator: MainMapCoordinatorProtocol {
    
    private let navigationController: UINavigationController
    private let dependencies: MainMapCoordinatorDependencies
    
    init(navigationController: UINavigationController,
         dependencies: MainMapCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start(startLocation: SearchLocationModel,
               goalLocation: SearchLocationModel) {
        let vc = dependencies.makeMainMapViewController(coordinator: self,
                                                        startLocation: startLocation,
                                                        goalLocation: goalLocation)
        navigationController.pushViewController(vc, animated: false)
    }
}
