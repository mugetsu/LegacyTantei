//
//  APIEnvironment.swift
//  Tantei
//
//  Created by Randell on 5/11/22.
//

import Foundation

enum APIEnvironment {
    case mal
    case jikan
    case trace
    
    var isMocked: Bool {
        return true
    }
    
    var headers: ReaquestHeaders? {
        switch self {
        case .mal:
            return [:]
        case .jikan:
            return [:]
        case .trace:
            return [:]
        }
    }
    
    var baseURL: String {
        switch self {
        case .mal:
            return Configuration.malURL.absoluteString
        case .jikan:
            return Configuration.jikanURL.absoluteString
        case .trace:
            return Configuration.traceURL.absoluteString
        }
    }
}
