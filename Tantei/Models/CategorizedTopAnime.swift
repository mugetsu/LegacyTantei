//
//  CategorizedTopAnime.swift
//  Tantei
//
//  Created by Randell on 1/11/22.
//

import Foundation

struct CategorizedTopAnime {
    let type: TopAnimeType
    var animes: [Jikan.AnimeDetails]?
    
    init(type: TopAnimeType, animes: [Jikan.AnimeDetails]? = nil) {
        self.type = type
        self.animes = animes
    }
}
