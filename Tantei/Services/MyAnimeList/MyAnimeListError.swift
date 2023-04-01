//
//  MyAnimeListError.swift
//  Tantei
//
//  Created by Randell Quitain on 1/4/23.
//

import Foundation

enum MyAnimeListError: Error {
    case invalidResponseFormat
    case nilRequest
    case nilData
    case other(reason: String)
}

extension MyAnimeListError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidResponseFormat:
            return "Invalid response format"
        case .nilRequest:
            return "Empty request"
        case .nilData:
            return "Empty data"
        case .other(let reason):
            return "Uhhh.. \(reason)"
        }
    }
}
