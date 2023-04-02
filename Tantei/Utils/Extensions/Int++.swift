//
//  Int++.swift
//  Tantei
//
//  Created by Randell Quitain on 2/4/23.
//

import Foundation

extension Int {
    
    func zeroPrefixed() -> String {
        return String(format: "%02d", self)
    }
}
