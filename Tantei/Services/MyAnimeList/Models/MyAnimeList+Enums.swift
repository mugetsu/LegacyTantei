//
//  MyAnimeList+Enums.swift
//  Tantei
//
//  Created by Randell Quitain on 1/4/23.
//

import Foundation

extension MyAnimeList {
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
    
    enum Matcher: String {
        case getTitleFromLazySynopsis = "(?<=season of|part of|arc of|sequel to).+?(?=.$|,|:)"
    }
}
