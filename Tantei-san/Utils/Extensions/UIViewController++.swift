//
//  UIViewController++.swift
//  Tantei-san
//
//  Created by Randell on 8/10/22.
//

import Foundation
import UIKit

extension UIViewController {
    func transitionToNewRootViewController(with viewController: UIViewController) {
        let scenes = UIApplication.shared.connectedScenes
        guard let windowScene = scenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
}
