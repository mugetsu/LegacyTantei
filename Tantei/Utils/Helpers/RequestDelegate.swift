//
//  RequestDelegate.swift
//  Tantei
//
//  Created by Randell on 28/9/22.
//

import Foundation

protocol RequestDelegate: AnyObject {
    func didUpdate(with state: ViewState)
}
