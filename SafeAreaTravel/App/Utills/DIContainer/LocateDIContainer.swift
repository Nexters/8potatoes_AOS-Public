//
//  LocateDIContainer.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/28/24.
//

import UIKit

final class LocateDIContainer: StartCoordinatorDependencies {
    
    struct Dependencies {
        let networking: Networking
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repositories
    func makeLocationInfoRepository() -> LocationInfoRepository {
        return LocationInfoDAO(network: dependencies.networking)
    }
    
    // MARK: - Use Cases
    func makeLocationInfoUseCase() -> LocationInfoUseCaseProtocol {
        return LocationInfoUseCase(repository: makeLocationInfoRepository())
    }
    
    // MARK: - Present
    func makeStartReactor(coordinator: StartCoordinator) -> StartReactor {
        return StartReactor(usecase: makeLocationInfoUseCase(), coordinator: coordinator)
    }
    
    func makeStartViewController(coordinator: StartCoordinator) -> StartViewController {
        return StartViewController(reactor: makeStartReactor(coordinator: coordinator))
    }
    
    func makeSearchLocationReactor(coordinator: StartCoordinator) -> SearchLocationReactor {
        return SearchLocationReactor(usecase: makeLocationInfoUseCase(), coordinator: coordinator)
    }
    
    func makeSearchLocationViewController(coordinator: StartCoordinator) -> SearchLocationViewController {
        return SearchLocationViewController(reactor: makeSearchLocationReactor(coordinator: coordinator))
    }
    
    // MARK: - Flow Coordinators
    
    func makeStartFlowCoordinator(navigationController: UINavigationController) -> StartCoordinator {
        return StartCoordinator(navigationController: navigationController, dependencies: self)
    }
}
