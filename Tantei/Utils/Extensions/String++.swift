//
//  String++.swift
//  Tantei
//
//  Created by Randell on 27/10/22.
//

import Foundation

extension String {
    
    func match(_ regex: String) -> [[String]] {
        let nsString = self as NSString
        return (try? NSRegularExpression(pattern: regex, options: [.caseInsensitive]))?
            .matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
            .map { match in
                (0..<match.numberOfRanges).map {
                    match.range(at: $0).location == NSNotFound
                        ? ""
                        : nsString.substring(with: match.range(at: $0))
                }
            } ?? []
    }
}
