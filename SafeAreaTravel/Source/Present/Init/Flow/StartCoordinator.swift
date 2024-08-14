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
    func makeMainMapViewController(coordinator: MainMapCoordinatorProtocol) -> MainMapViewController
    func makeMainMapFlowCoordinator(navigationController: UINavigationController) -> MainMapCoordinator
}
protocol StartCoordinatorProtocol {
    func start()
    func presentSearchViewController(reactor: SearchLocationReactor)
    func dismissSearchViewController()
    func pushMainMapViewController()
    func pushCurrentLocationViewController()
}

final class StartCoordinator: StartCoordinatorProtocol {
        
    private let navigationController: UINavigationController
    private let dependencies: StartCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: StartCoordinatorDependencies) {
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
    
    func pushCurrentLocationViewController() {
        log.warning("푸시")
        self.navigationController.dismiss(animated: false, completion: nil)
        let vc = CurrentLocationViewController()
        navigationController.pushViewController(vc, animated: false)
    }
    
    func dismissSearchViewController() {
        navigationController.dismiss(animated: true)
    }
    
    func pushMainMapViewController() {
        let mainMapFlowCoordinator = dependencies.makeMainMapFlowCoordinator(navigationController: navigationController)
        mainMapFlowCoordinator.start()
    }
}

