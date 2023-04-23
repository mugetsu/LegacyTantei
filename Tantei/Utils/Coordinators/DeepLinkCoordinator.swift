//
//  DeepLinkCoordinator.swift
//  Tantei
//
//  Created by Randell on 4/10/22.
//

import Foundation

class DeepLinkCoordinator: DeepLinkBaseCoordinator {
    var parentCoordinator: MainBaseCoordinator?
    
    init(mainBaseCoordinator: MainBaseCoordinator) {
        self.parentCoordinator = mainBaseCoordinator
    }
    
    func handleDeeplink(deepLink: String) {
        print("")
    }
}
