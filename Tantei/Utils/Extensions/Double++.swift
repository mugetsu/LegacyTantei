//
//  Double++.swift
//  Tantei
//
//  Created by Randell Quitain on 2/4/23.
//

import Foundation

extension Double {
    
    func formatScore() -> String {
        if self <= 0 {
            return "N/A"
        } else {
            return String(format: "%.1f★", self)
        }
    }
}
