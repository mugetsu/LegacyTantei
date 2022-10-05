//
//  DashboardCoordinator.swift
//  Tantei-san
//
//  Created by Randell on 4/10/22.
//

import UIKit

class DashboardCoordinator: DashboardBaseCoordinator {

    var parentCoordinator: MainBaseCoordinator?
    
    lazy var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        let viewModel = DashboardViewModel()
        rootViewController = UINavigationController(
            rootViewController: DashboardViewController(
                viewModel: viewModel,
                coordinator: self
            )
        )
        return rootViewController
    }
    
    func moveTo(flow: AppFlow) {
        switch flow {
        case .dashboard(let screen):
            handleDashboardFlow(for: screen)
        default:
            parentCoordinator?.moveTo(flow: flow)
        }
    }
    
    private func handleDashboardFlow(for screen: DashboardScreen) {
        switch screen {
        case .initial:
            navigationRootViewController?.popToRootViewController(animated: true)
        }
    }
    
    func resetToRoot() -> Self {
        navigationRootViewController?.popToRootViewController(animated: false)
        return self
    }
}
