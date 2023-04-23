//
//  UIFont++.swift
//  Tantei
//
//  Created by Randell on 1/10/22.
//

import UIKit

extension UIView {
    
    static func spacer(size: CGFloat = 4, for layout: NSLayoutConstraint.Axis = .horizontal) -> UIView {
        let spacer = UIView()
        if layout == .horizontal {
            spacer.widthAnchor.constraint(equalToConstant: size).isActive = true
        } else {
            spacer.heightAnchor.constraint(equalToConstant: size).isActive = true
        }
        return spacer
    }
}
