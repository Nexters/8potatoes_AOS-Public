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
        let reactor = CurrentLocationReactor(usecase: LocationInfoUseCase(repository: LocationInfoDAO(network: Networking())), coordinator: self)
        let vc = CurrentLocationViewController(reactor: reactor)
        vc.modalPresentationStyle = .fullScreen
        navigationController.presentedViewController?.present(vc, animated: true, completion: nil)
    }
    
    func dismissSearchViewController() {
        navigationController.dismiss(animated: true)
    }
    
    func pushMainMapViewController() {
        let mainMapFlowCoordinator = dependencies.makeMainMapFlowCoordinator(navigationController: navigationController)
        mainMapFlowCoordinator.start()
    }
    
    func dismissViewController() {
        navigationController.dismiss(animated: true)
    }
}

