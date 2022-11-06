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
    var topAnime: [Jikan.AnimeDetails] = []
}
