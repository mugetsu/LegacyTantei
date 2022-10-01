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
        let firstCoordinator = DashboardCoordinator()
        let secondCoordinator = SearchCoordinator()
        firstTabNavigationController = firstCoordinator.navigationController
        secondTabNavigationController = secondCoordinator.navigationController
        viewControllers = [firstTabNavigationController, secondTabNavigationController]
        let item1 = UITabBarItem(title: "Dashboard", image: UIImage(named: "home")!.withRenderingMode(.alwaysOriginal), tag: 0)
        let item2 = UITabBarItem(title: "Search", image: UIImage(named: "search")!.withRenderingMode(.alwaysOriginal), tag: 1)
        
        let tabItemNormal = [
            NSAttributedString.Key.font: UIFont(name: "InterTight-Medium", size: 16)!
        ]
        
        let tabItemSelected = [
            NSAttributedString.Key.font: UIFont(name: "InterTight-Medium", size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        item1.setTitleTextAttributes(tabItemNormal, for: .normal)
        item2.setTitleTextAttributes(tabItemNormal, for: .normal)
        
        item1.setTitleTextAttributes(tabItemSelected, for: .selected)
        item2.setTitleTextAttributes(tabItemSelected, for: .selected)
        
        firstTabNavigationController.tabBarItem = item1
        secondTabNavigationController.tabBarItem = item2
    }
}
