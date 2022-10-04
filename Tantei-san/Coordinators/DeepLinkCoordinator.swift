//
//  DeepLinkCoordinator.swift
//  Tantei-san
//
//  Created by Randell on 4/10/22.
//

import Foundation

class DeepLinkCoordinator: DeepLinkBaseCoordinator {
    
    func handleDeeplink(deepLink: String) {
        print("")
    }
    
    var parentCoordinator: MainBaseCoordinator?
    
    init(mainBaseCoordinator: MainBaseCoordinator) {
        self.parentCoordinator = mainBaseCoordinator
    }
}
