//
//  StartCoordinator.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/28/24.
//

import UIKit

protocol StartCoordinatorDependencies {
    func makeStartViewController(coordinator: StartCoordinatorProtocol) -> StartViewController
    func makeSearchLocationViewController(coordinator: StartCoordinatorProtocol) -> SearchLocationViewController
}

protocol StartCoordinatorProtocol {
    func start()
    func presentSearchViewController(reactor: SearchLocationReactor)
    func dismissSearchViewController()
}

final class StartCoordinator: StartCoordinatorProtocol {
        
    private let navigationController: UINavigationController
    private let dependencies: StartCoordinatorDependencies
    
    init(navigationController: UINavigationController,
         dependencies: StartCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let vc = dependencies.makeStartViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func presentSearchViewController(reactor: SearchLocationReactor) {
        let vc = SearchLocationViewController(reactor: reactor)
        vc.modalPresentationStyle = .automatic
        navigationController.present(vc, animated: true)
    }
    
    func dismissSearchViewController() {
        navigationController.dismiss(animated: true)
    }
}

