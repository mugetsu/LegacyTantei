//
//  MainBaseCoordinator.swift
//  Tantei-san
//
//  Created by Randell on 4/10/22.
//

import Foundation

protocol MainBaseCoordinator: Coordinator {
    var authenticationCoordinator: AuthenticationBaseCoordinator { get }
    var dashboardCoordinator: DashboardBaseCoordinator { get }
    var searchCoordinator: SearchBaseCoordinator { get }
    var deepLinkCoordinator: DeepLinkBaseCoordinator { get }
    func handleDeepLink(text: String)
}

protocol AuthenticationBaseCoordinated {
    var coordinator: AuthenticationBaseCoordinator? { get }
}

protocol DashboardBaseCoordinated {
    var coordinator: DashboardBaseCoordinator? { get }
}

protocol SearchBaseCoordinated {
    var coordinator: SearchBaseCoordinator? { get }
}
