//
//  AuthenticationCoordinator.swift
//  Tantei
//
//  Created by Randell on 8/10/22.
//

import UIKit

class AuthenticationCoordinator: AuthenticationBaseCoordinator {
    var parentCoordinator: MainBaseCoordinator?
    
    lazy var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        let viewModel = AuthenticationViewModel()
        rootViewController = UINavigationController(
            rootViewController: AuthenticationView(
                viewModel: viewModel,
                coordinator: self
            )
        )
        return rootViewController
    }
    
    func moveTo(flow: AppFlow) {
        switch flow {
        case .authentication(let screen):
            handleAuthenticationFlow(for: screen)
        default:
            parentCoordinator?.moveTo(flow: flow)
        }
    }
    
    private func handleAuthenticationFlow(for screen: AuthenticationScreen) {
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
