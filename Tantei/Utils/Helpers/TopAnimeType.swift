//
//  TopAnimeType.swift
//  Tantei
//
//  Created by Randell on 31/10/22.
//

import Foundation

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
