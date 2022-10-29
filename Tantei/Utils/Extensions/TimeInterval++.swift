//
//  TimeInterval++.swift
//  Tantei-san
//
//  Created by Randell on 1/10/22.
//

import Foundation

extension TimeInterval {
    
    func getMinutes() -> String {
        let duration: TimeInterval = self
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let start = cal.startOfDay(for: date)
        let newDate = start.addingTimeInterval(duration)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: newDate)
    }
}
