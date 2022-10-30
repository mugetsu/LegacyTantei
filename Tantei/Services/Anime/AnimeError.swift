//
//  AnimeError.swift
//  Tantei
//
//  Created by Randell on 28/9/22.
//

import Foundation

enum AnimeError {
    case timeOut,
         notConnected,
         other(reason: String)
}

extension AnimeError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .timeOut:
            return "Session timed out"
        case .notConnected:
            return "No internet connection"
        case .other(let reason):
            return "Uhhh.. \(reason)"
        }
    }
}
