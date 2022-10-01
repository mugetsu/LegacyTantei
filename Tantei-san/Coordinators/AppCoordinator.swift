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
            self.window.rootViewController = self.rootViewController
        }
    }
    
    public init(window: UIWindow) {
        self.window = window
        self.window.backgroundColor = UIColor.Palette.black
        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()
    }
    
    private func setCurrentCoordinator(_ coordinator: RootViewCoordinator) {
        rootViewController = coordinator.rootViewController
    }
    
    func start() {
        let initialCordinator = TabBarCoordinator()
        addChildCoordinator(initialCordinator)
        setCurrentCoordinator(initialCordinator)
    }
}
