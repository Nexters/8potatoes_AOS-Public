//
//  SafeAreaDIContainer.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import UIKit

final class SafeAreaDIContainer: MainMapCoordinatorDependencies {
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
    func makeMainMapReactor(coordinator: MainMapCoordinator) -> MainMapReactor {
        return(MainMapReactor(usecase: makeLocationInfoUseCase(),
                              coordinator: coordinator))
    }
    
    func makeMainMapViewController(coordinator: MainMapCoordinatorProtocol) -> MainMapViewController {
        return MainMapViewController(reactor: makeMainMapReactor(coordinator: coordinator as! MainMapCoordinator))
    }
    
    // MARK: - Flow Coordinators
    
    func makeMainMapFlowCoordinator(navigationController: UINavigationController) -> MainMapCoordinator {
        return MainMapCoordinator(navigationController: navigationController,
                                  dependencies: self)
    }
}
