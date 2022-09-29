//
//  AppCoordinator.swift
//  Tantei-san
//
//  Created by Randell on 29/9/22.
//

import Foundation
import UIKit

class AppCoordinator: RootViewCoordinator {
    var childCoordinators: [Coordinator] = []
    
    private(set) var rootViewController: UIViewController = SplashViewController() {
        didSet {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.window.rootViewController = self.rootViewController
            })
        }
    }
    
    /// Window to manage
    let window: UIWindow
    
    // MARK: - Init
    public init(window: UIWindow) {
        self.window = window
        self.window.backgroundColor = .white
        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()
    }
    
    // MARK: - Functions
    private func setCurrentCoordinator(_ coordinator: RootViewCoordinator) {
        rootViewController = coordinator.rootViewController
    }
    
    /// Starts the coordinator
    func start() {
        let searchCoordinator = SearchCoordinator()
        addChildCoordinator(searchCoordinator)
        setCurrentCoordinator(searchCoordinator)
    }
}
