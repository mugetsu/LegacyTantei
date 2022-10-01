//
//  SceneDelegate.swift
//  Tantei-san
//
//  Created by Randell on 1/10/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        self.appCoordinator = AppCoordinator(window: window!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.appCoordinator.start()
        }
    }
}
