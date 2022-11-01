//
//  LocalContext.swift
//  Tantei
//
//  Created by Randell on 31/10/22.
//

import Foundation

class LocalContext {
    static var shared = LocalContext()
    
    var topAnimes: [CategorizedTopAnime] = []
    
    var topAiringAnimes: [Jikan.AnimeDetails] = []
    var topUpcomingAnimes: [Jikan.AnimeDetails] = []
    var topPopularAnimes: [Jikan.AnimeDetails] = []
    var topFavoriteAnimes: [Jikan.AnimeDetails] = []
}
