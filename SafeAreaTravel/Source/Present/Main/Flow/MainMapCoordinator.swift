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
                                   goalLocation: SearchLocationModel,
                                   route: Route) -> MainMapViewController
}

protocol MainMapCoordinatorProtocol {
    func start(startLocation: SearchLocationModel, goalLocation: SearchLocationModel, route: Route)
}

final class MainMapCoordinator: MainMapCoordinatorProtocol {
    
    private let navigationController: UINavigationController
    private let dependencies: MainMapCoordinatorDependencies
    
    init(navigationController: UINavigationController,
         dependencies: MainMapCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.navigationController.interactivePopGestureRecognizer?.isEnabled = false
    }

    func start(startLocation: SearchLocationModel,
               goalLocation: SearchLocationModel,
               route: Route) {
        let vc = dependencies.makeMainMapViewController(coordinator: self,
                                                        startLocation: startLocation,
                                                        goalLocation: goalLocation,
                                                        route: route)
        navigationController.pushViewController(vc, animated: false)
    }
}
