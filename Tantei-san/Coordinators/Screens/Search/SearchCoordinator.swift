//
//  SearchCoordinator.swift
//  Tantei-san
//
//  Created by Randell on 4/10/22.
//

import UIKit

class SearchCoordinator: SearchBaseCoordinator {

    var parentCoordinator: MainBaseCoordinator?
    
    lazy var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        let viewModel = SearchViewModel()
        rootViewController = UINavigationController(
            rootViewController: SearchViewController(
                viewModel: viewModel,
                coordinator: self
            )
        )
        return rootViewController
    }
    
    func moveTo(flow: AppFlow) {
        switch flow {
        case .search(let screen):
            handleSearchFlow(for: screen)
        default:
            parentCoordinator?.moveTo(flow: flow)
        }
    }
    
    private func handleSearchFlow(for screen: SearchScreen) {
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
