//
//  TabBarCoordinator.swift
//  Tantei-san
//
//  Created by Randell on 1/10/22.
//

import Foundation
import UIKit

class TabBarCoordinator: RootViewCoordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var rootViewController: UIViewController {
        return self.navigationController
    }
    
    var navigationController: UINavigationController = {
        let viewController = TabBarViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }()
    
    func start() {}
}

