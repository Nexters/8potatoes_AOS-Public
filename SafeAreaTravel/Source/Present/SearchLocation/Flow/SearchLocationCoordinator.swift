//
//  SearchLocationCoordinator.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/28/24.
//

import UIKit

protocol SearchLocationCoordinatorDependencies {
    func makeSearchLocationViewController(coordinator: SearchLocationCoordinator) -> SearchLocationViewController
}

protocol SearchLocationCoordinatorProtocol {
    func start()
}

final class SearchLocationCoordinator: SearchLocationCoordinatorProtocol {
    
    private let navigationController: UINavigationController
    private let dependencies: SearchLocationCoordinatorDependencies
    
    init(navigationController: UINavigationController,
         dependencies: SearchLocationCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let vc = dependencies.makeSearchLocationViewController(coordinator: self)
        navigationController.present(vc, animated: true)
    }
}
