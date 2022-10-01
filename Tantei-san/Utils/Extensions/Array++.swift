//
//  Array++.swift
//  Tantei-san
//
//  Created by Randell on 30/9/22.
//

import Foundation

extension Array {
    
    func unique<T:Hashable>(by: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>()
        var arrayOrdered = [Element]()
        for value in self {
            if !set.contains(by(value)) {
                set.insert(by(value))
                arrayOrdered.append(value)
            }
        }
        return arrayOrdered
    }
}
