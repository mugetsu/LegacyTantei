//
//  RootCoordinator.swift
//  Tantei-san
//
//  Created by Randell on 29/9/22.
//

import Foundation
import UIKit

public protocol RootControllerProvider: AnyObject {
    var rootViewController: UIViewController { get }
    func start()
}

public typealias RootCoordinator = Coordinator & RootControllerProvider
