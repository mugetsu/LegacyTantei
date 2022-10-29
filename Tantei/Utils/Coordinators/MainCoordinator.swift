//
//  MainCoordinator.swift
//  Tantei-san
//
//  Created by Randell on 4/10/22.
//

import UIKit

class MainCoordinator: MainBaseCoordinator {
    var parentCoordinator: MainBaseCoordinator?
    
    lazy var authenticationCoordinator: AuthenticationBaseCoordinator = AuthenticationCoordinator()
    lazy var dashboardCoordinator: DashboardBaseCoordinator = DashboardCoordinator()
    lazy var searchCoordinator: SearchBaseCoordinator = SearchCoordinator()
    lazy var deepLinkCoordinator: DeepLinkBaseCoordinator = DeepLinkCoordinator(mainBaseCoordinator: self)
    
    lazy var rootViewController: UIViewController = UITabBarController()
    
    func start() -> UIViewController {
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        let offsetTabImage = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = UIColor.Elements.backgroundDark
        UITabBar.appearance().backgroundColor = UIColor.Elements.backgroundDark
        UITabBar.appearance().standardAppearance = tabBarAppearance
        
        let dashboardViewController = dashboardCoordinator.start()
        let dashboardTabItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "home"),
            tag: 0
        )
        dashboardTabItem.imageInsets = offsetTabImage
        dashboardCoordinator.parentCoordinator = self
        dashboardViewController.tabBarItem = dashboardTabItem
        
        let searchViewController = searchCoordinator.start()
        let searchTabItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "search"),
            tag: 1
        )
        searchTabItem.imageInsets = offsetTabImage
        searchCoordinator.parentCoordinator = self
        searchViewController.tabBarItem = searchTabItem
        
        (rootViewController as? UITabBarController)?.viewControllers = [dashboardViewController, searchViewController]
        
        return rootViewController
    }
        
    func moveTo(flow: AppFlow) {
        switch flow {
        case .authentication:
            goToAuthenticationFlow(flow)
        case .dashboard:
            goToDashboardFlow(flow)
        case .search:
            goToSearchFlow(flow)
        }
    }
    
    private func goToAuthenticationFlow(_ flow: AppFlow) {
        authenticationCoordinator.moveTo(flow: flow)
    }
    
    private func goToDashboardFlow(_ flow: AppFlow) {
        dashboardCoordinator.moveTo(flow: flow)
        (rootViewController as? UITabBarController)?.selectedIndex = 0
    }
    
    private func goToSearchFlow(_ flow: AppFlow) {
        searchCoordinator.moveTo(flow: flow)
        (rootViewController as? UITabBarController)?.selectedIndex = 1
    }
    
    func handleDeepLink(text: String) {
        deepLinkCoordinator.handleDeeplink(deepLink: text)
    }
    
    func resetToRoot() -> Self {
        dashboardCoordinator.resetToRoot(animated: false)
        moveTo(flow: .dashboard(.initial))
        return self
    }
    
}
