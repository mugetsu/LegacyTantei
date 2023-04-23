//
//  AnimeError.swift
//  Tantei
//
//  Created by Randell on 28/9/22.
//

import Foundation

enum APIError {
    case badRequest,
         nilResponse,
         serverError,
         unknown
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badRequest:
            return "Bad request"
        case .nilResponse:
            return "Empty response"
        case .serverError:
            return "Server error"
        case .unknown:
            return "Unknown"
        }
    }
}
