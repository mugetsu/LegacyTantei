//
//  AnimeError.swift
//  Tantei-san
//
//  Created by Randell on 28/9/22.
//

import Foundation

enum AnimeError {
    case timeOut
    case notConnected
    case exceededLimit
    case other
}

extension AnimeError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .timeOut:
            return "Session timed out"
        case .notConnected:
            return "No internet connection"
        case .exceededLimit:
            return "Concurrency limit exceeded"
        case .other:
            return "Something weird happened"
        }
    }
}
