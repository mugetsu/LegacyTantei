//
//  UILabel+XLabel.swift
//  Tantei-san
//
//  Created by Randell on 1/10/22.
//

import Foundation
import UIKit

class XLabel: UILabel {
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let addedHeight = font.pointSize * 0.5
        return CGSize(width: size.width, height: size.height + addedHeight)
    }
}
