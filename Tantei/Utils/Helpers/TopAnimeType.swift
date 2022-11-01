//
//  TopAnimeType.swift
//  Tantei
//
//  Created by Randell on 31/10/22.
//

import Foundation

enum TopAnimeType: String, Codable {
    case airing = "airing",
         upcoming = "upcoming",
         byPopularity = "bypopularity",
         favorite = "favorite"
}
