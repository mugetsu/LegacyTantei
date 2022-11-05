//
//  APIEnvironment.swift
//  Tantei
//
//  Created by Randell on 5/11/22.
//

import Foundation

enum APIEnvironment {
    case jikan
    case trace
    
    var isMocked: Bool {
        return true
    }
    
    var headers: ReaquestHeaders? {
        switch self {
        case .jikan:
            return [:]
        case .trace:
            return [:]
        }
    }
    
    var baseURL: String {
        switch self {
        case .jikan:
            return "https://api.jikan.moe/v4"
        case .trace:
            return "https://api.trace.moe"
        }
    }
}
