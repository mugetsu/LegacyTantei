//
//  TraceError.swift
//  Tantei
//
//  Created by Randell on 6/11/22.
//

import Foundation

enum TraceError: Error {
    case invalidResponseFormat
    case nilRequest
    case nilData
    case other(reason: String)
}

extension TraceError: LocalizedError {
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
