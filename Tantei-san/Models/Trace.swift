//
//  Trace.swift
//  Tantei-san
//
//  Created by Randell on 28/9/22.
//

import Foundation

struct Trace {
    
    struct Anime: Codable {
        var error: String?
        var result: [AnimeResult]?
        
        init(error: String? = nil, result: [AnimeResult]? = nil) {
            self.error = error
            self.result = result
        }
    }
    
    struct AnimeResult: Codable {
        let anilist: AnimeAniList
        var filename: String?
        var episode: Int?
        var image: String?
        
        init(anilist: Trace.AnimeAniList, filename: String? = nil, episode: Int? = nil, image: String? = nil) {
            self.anilist = anilist
            self.filename = filename
            self.episode = episode
            self.image = image
        }
    }

    struct AnimeAniList: Codable {
        let id: Int
        let idMal: Int?
        var title: AnimeAniListTitle?
        var synonyms: [String]?
        var isAdult: Bool?
        
        init(id: Int, idMal: Int, title: AnimeAniListTitle? = nil, synonyms: [String]? = nil, isAdult: Bool? = nil) {
            self.id = id
            self.idMal = idMal
            self.title = title
            self.synonyms = synonyms
            self.isAdult = isAdult
        }
    }

    struct AnimeAniListTitle: Codable {
        var native: String?
        var romaji: String?
        var english: String?
        
        init(native: String? = nil, romaji: String? = nil, english: String? = nil) {
            self.native = native
            self.romaji = romaji
            self.english = english
        }
    }
}
