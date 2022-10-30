//
//  SceneDelegate.swift
//  Tantei
//
//  Created by Randell on 1/10/22.
//

import FirebaseCore
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        
        FirebaseApp.configure()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = launchScreen
        window?.makeKeyAndVisible()
        
        let textAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        UINavigationBar.appearance().largeTitleTextAttributes = textAttributes
        
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
