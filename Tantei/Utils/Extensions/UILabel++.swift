//
//  UILabel++.swift
//  Tantei
//
//  Created by Randell on 30/10/22.
//

import Foundation
import UIKit

extension UILabel {
    
    func setLineSpacing(lineSpacing: CGFloat, textAlignment: NSTextAlignment ) {
        guard let text = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        if lineSpacing < 0 {
            paragraphStyle.lineSpacing = 0
            paragraphStyle.maximumLineHeight = self.font.pointSize + lineSpacing
        } else {
            paragraphStyle.lineSpacing = lineSpacing
        }
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSMakeRange(0, attrString.length)
        )
        self.attributedText = attrString
        self.textAlignment = textAlignment
    }
}
