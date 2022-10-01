//
//  AnimeService.swift
//  Tantei-san
//
//  Created by Randell on 28/9/22.
//

import Foundation

final class AnimeService {
    static let isMocked = true
    
    enum API {
        case jikan
        case trace
        
        var url: String {
            switch self {
            case .jikan:
                return "https://api.jikan.moe/v4"
            case .trace:
                return "https://api.trace.moe"
            }
        }
    }
    
    enum Endpoint {
        case searchByURL(_ api: API)
        
        var url: String {
            switch self {
            case let .searchByURL(api):
                return "\(api.url)/search"
            }
        }
    }
}
