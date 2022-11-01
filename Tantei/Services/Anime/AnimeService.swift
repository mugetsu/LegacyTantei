//
//  AnimeService.swift
//  Tantei
//
//  Created by Randell on 28/9/22.
//

import Foundation

final class AnimeService {
    static let isMocked = true
    
    enum API {
        case jikan,
             trace
        
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
        case topAnime(_ api: API),
             search(_ api: API),
             searchByURL(_ api: API),
             getRelations(_ api: API, id: Int),
             getAnimeBy(_ api: API, id: Int)
        
        var url: String {
            switch self {
            case let .topAnime(api):
                return "\(api.url)/top/anime"
            case let .search(api):
                return "\(api.url)/anime"
            case let .searchByURL(api):
                return "\(api.url)/search"
            case let .getRelations(api, id):
                return "\(api.url)/anime/\(id)/relations"
            case let .getAnimeBy(api, id):
                return "\(api.url)/anime/\(id)"
            }
        }
    }
}
