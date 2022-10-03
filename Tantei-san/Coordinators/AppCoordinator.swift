//
//  AppCoordinator.swift
//  Tantei-san
//
//  Created by Randell on 29/9/22.
//

import Foundation
import UIKit

class AppCoordinator: RootViewCoordinator {
    
    let window: UIWindow
    var childCoordinators: [Coordinator] = []
    
    private(set) var rootViewController: UIViewController = SplashViewController() {
        didSet {
             UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                 self.window.rootViewController = self.rootViewController
             })
        }
    }
    
    public init(window: UIWindow) {
        self.window = window
        self.window.backgroundColor = UIColor.Elements.backgroundLight
        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()
    }
    
    private func setCurrentCoordinator(_ coordinator: RootViewCoordinator) {
        rootViewController = coordinator.rootViewController
    }
    
    func start() {
        let tabBarViewController = TabBarViewController()
        self.window.rootViewController = tabBarViewController
        self.window.makeKeyAndVisible()
    }
}
