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
             searchByURL(_ api: API)
        
        var url: String {
            switch self {
            case .topAnime(let api):
                return "\(api.url)/top/anime"
            case .searchByURL(let api):
                return "\(api.url)/search"
            }
        }
    }
    
    enum SearchQueryType: String, Codable {
        case tv = "tv",
             movie = "movie",
             ova = "ova",
             special = "special",
             ona = "ona",
             music = "music"
    }
    
    enum SearchFilterType: String, Codable {
        case airing = "airing",
             upcoming = "upcoming",
             popularity = "bypopularity",
             favorite = "favorite"
    }
}
