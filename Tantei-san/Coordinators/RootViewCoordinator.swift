//
//  RootViewCoordinator.swift
//  Tantei-san
//
//  Created by Randell on 29/9/22.
//

import Foundation
import UIKit

public protocol RootViewControllerProvider: AnyObject {
    var rootViewController: UIViewController { get }
    func start()
}

public typealias RootViewCoordinator = Coordinator & RootViewControllerProvider
