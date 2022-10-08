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
        let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = launchScreen
        window?.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            guard let window = self.window else { return }
            window.rootViewController = MainCoordinator().authenticationCoordinator.start()
            window.makeKeyAndVisible()
            UIView.transition(
                with: window,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: nil
            )
        }
    }
}
