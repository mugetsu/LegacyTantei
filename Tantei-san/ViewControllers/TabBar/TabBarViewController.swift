//
//  TabBarViewController.swift
//  Tantei-san
//
//  Created by Randell on 1/10/22.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var firstTabNavigationController : UINavigationController!
    var secondTabNavigationController : UINavigationController!
    
    required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.delegate = self
        
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = UIColor.Elements.backgroundLight
        UITabBar.appearance().backgroundColor = UIColor.Elements.backgroundLight
        UITabBar.appearance().standardAppearance = tabBarAppearance
        
        let firstCoordinator = DashboardCoordinator()
        let secondCoordinator = SearchCoordinator()
        
        firstTabNavigationController = firstCoordinator.navigationController
        secondTabNavigationController = secondCoordinator.navigationController
        
        viewControllers = [
            firstTabNavigationController,
            secondTabNavigationController
        ]
        
        let item1 = UITabBarItem(title: nil, image: UIImage(named: "home")!.withRenderingMode(.alwaysOriginal), tag: 0)
        let item2 = UITabBarItem(title: nil, image: UIImage(named: "search")!.withRenderingMode(.alwaysOriginal), tag: 1)
        
        
        item1.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        item2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        firstTabNavigationController.tabBarItem = item1
        secondTabNavigationController.tabBarItem = item2
    }
}

//extension TabBarViewController: UITabBarControllerDelegate {
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        guard let fromView = selectedViewController?.view,
//              let toView = viewController.view else {
//            return false
//        }
//
//        if fromView != toView {
//            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
//        }
//
//        return true
//    }
//}
