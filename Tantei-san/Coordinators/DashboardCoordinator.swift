//
//  DashboardCoordinator.swift
//  Tantei-san
//
//  Created by Randell on 1/10/22.
//

import Foundation
import UIKit

class DashboardCoordinator: RootViewCoordinator {
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController {
        return self.navigationController
    }
    
    private var navigationController: UINavigationController = {
        let viewModel = DashboardViewModel()
        let viewController = DashboardViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }()
    
    func start() {}
}

