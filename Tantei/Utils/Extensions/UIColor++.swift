//
//  UIColor++.swift
//  Tantei
//
//  Created by Randell on 30/9/22.
//

import UIKit

extension UIColor {
    
    struct Elements {
        static let backgroundDark = UIColor("#16161a")
        static let backgroundLight = UIColor("#242629")
        static let headline = UIColor("#fffffe")
        static let subHeadline = UIColor("#94a1b2")
        static let paragraph = UIColor("#94a1b2")
        static let button = UIColor("#7f5af0")
        static let buttonText = UIColor("#fffffe")
        static let cardBackground = UIColor("#16161a")
        static let cardHeading = UIColor("#fffffe")
        static let cardParagraph = UIColor("#94a1b2")
    }
    
    struct Illustration {
        static let stroke = UIColor("#010101")
        static let main = UIColor("#fffffe")
        static let highlight = UIColor("#7f5af0")
        static let secondary = UIColor("#72757e")
        static let tertiary = UIColor("#2cb67d")
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
