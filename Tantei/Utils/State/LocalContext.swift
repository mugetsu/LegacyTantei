//
//  LocalContext.swift
//  Tantei
//
//  Created by Randell on 31/10/22.
//

import Foundation

class LocalContext {
    static var shared = LocalContext()
    
    var scheduledForToday: [Jikan.AnimeDetails] = []
    
    var topAiring: [Jikan.AnimeDetails] = []
    var topUpcoming: [Jikan.AnimeDetails] = []
    var topPopular: [Jikan.AnimeDetails] = []
    var topFavorite: [Jikan.AnimeDetails] = []
    
    var topAnimes: [CategorizedTopAnime] = []
}
