//
//  UIColor++.swift
//  Tantei-san
//
//  Created by Randell on 30/9/22.
//

import UIKit

extension UIColor {
    
    struct Palette {
        static let black = UIColor("#181818")
        static let purple = UIColor("#8758FF")
        static let blue = UIColor("#5CB8E4")
        static let grey = UIColor("#F2F2F2")
    }
    
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") { cString.removeFirst() }
        if cString.count != 6 {
            self.init("ff0000") // return red color for wrong hex input
            return
        }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
