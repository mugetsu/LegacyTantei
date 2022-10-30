//
//  DeepLinkBaseCoordinator.swift
//  Tantei
//
//  Created by Randell on 4/10/22.
//

import Foundation

protocol DeepLinkBaseCoordinator: FlowCoordinator {
    func handleDeeplink(deepLink: String)
}
