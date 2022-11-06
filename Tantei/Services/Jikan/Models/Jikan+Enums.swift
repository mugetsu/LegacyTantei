//
//  Jikan+Enums.swift
//  Tantei
//
//  Created by Randell on 6/11/22.
//

import Foundation

extension Jikan {    
    enum AnimeType: String, Codable {
        case tv = "tv",
             movie = "movie",
             ova = "ova",
             special = "special",
             ona = "ona",
             music = "music"
    }
    
    enum TopAnimeType: String, CaseIterable, Codable {
        case airing = "airing",
             upcoming = "upcoming",
             popular = "bypopularity",
             favorite = "favorite"
        
        var description: String {
            switch self {
            case .airing: return "Airing"
            case .upcoming: return "Upcoming"
            case .popular: return "Popular"
            case .favorite: return "Favorite"
            }
        }
    }
}
