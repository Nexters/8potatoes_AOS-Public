//
//  SafeAreaDIContainer.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import UIKit

final class SafeAreaDIContainer: StartCoordinatorDependencies, MainMapCoordinatorDependencies {
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
    
    // MARK: - Present (Start)
    
    func makeStartReactor(coordinator: StartCoordinatorProtocol) -> StartReactor {
        return StartReactor(usecase: makeLocationInfoUseCase(), coordinator: coordinator)
    }
    
    func makeStartViewController(coordinator: StartCoordinatorProtocol) -> StartViewController {
        return StartViewController(reactor: makeStartReactor(coordinator: coordinator))
    }
    
    // MARK: - Present (Search)
    
    func makeSearchLocationReactor(coordinator: StartCoordinatorProtocol) -> SearchLocationReactor {
        return SearchLocationReactor(usecase: makeLocationInfoUseCase(), coordinator: coordinator)
    }
    
    func makeSearchLocationViewController(coordinator: StartCoordinatorProtocol) -> SearchLocationViewController {
        return SearchLocationViewController(reactor: makeSearchLocationReactor(coordinator: coordinator))
    }
    
    // MARK: - Present (MainMap)
    
    func makeMainMapReactor(coordinator: MainMapCoordinator,
                            startLocation: SearchLocationModel,
                            goalLocation: SearchLocationModel,
                            route: Route) -> MainMapReactor {
        return MainMapReactor(usecase: makeLocationInfoUseCase(), coordinator: coordinator,
                              startLocation: startLocation, goalLocation: goalLocation, route: route)
    }
    
    func makeMainMapViewController(coordinator: MainMapCoordinatorProtocol,
                                   startLocation: SearchLocationModel,
                                   goalLocation: SearchLocationModel,
                                   route: Route) -> MainMapViewController {
        return MainMapViewController(reactor: makeMainMapReactor(coordinator: coordinator as! MainMapCoordinator,
                                                                 startLocation: startLocation,
                                                                 goalLocation: goalLocation,
                                                                 route: route))
    }
    
    // MARK: - Flow Coordinators
    
    func makeStartFlowCoordinator(navigationController: UINavigationController) -> StartCoordinator {
        return StartCoordinator(navigationController: navigationController, dependencies: self)
    }

    func makeMainMapFlowCoordinator(navigationController: UINavigationController) -> MainMapCoordinator {
        return MainMapCoordinator(navigationController: navigationController, dependencies: self)
    }
}
