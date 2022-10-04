//
//  SceneDelegate.swift
//  Tantei-san
//
//  Created by Randell on 1/10/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        window?.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.window?.rootViewController = MainCoordinator().start()
            self.window?.makeKeyAndVisible()
        }
    }
}
