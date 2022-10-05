//
//  Trace.swift
//  Tantei-san
//
//  Created by Randell on 28/9/22.
//

import Foundation

struct Trace {
    
    struct Anime: Codable {
        var error: String?,
            result: [AnimeDetails]?
        
        init(error: String? = nil, result: [Trace.AnimeDetails]? = nil) {
            self.error = error
            self.result = result
        }
    }
    
    struct AnimeDetails: Codable {
        let anilist: AnimeAniList
        var episode: Int?,
            from: TimeInterval?,
            to: TimeInterval?,
            similarity: Decimal?,
            image: String?
        
        init(anilist: Trace.AnimeAniList, episode: Int? = nil, from: TimeInterval? = nil, to: TimeInterval? = nil, similarity: Decimal? = nil, image: String? = nil) {
            self.anilist = anilist
            self.episode = episode
            self.from = from
            self.to = to
            self.similarity = similarity
            self.image = image
        }
    }

    struct AnimeAniList: Codable {
        let id: Int,
            idMal: Int
        var title: AnimeAniListTitle?,
            isAdult: Bool?
        
        init(id: Int, idMal: Int, title: Trace.AnimeAniListTitle? = nil, isAdult: Bool? = nil) {
            self.id = id
            self.idMal = idMal
            self.title = title
            self.isAdult = isAdult
        }
    }

    struct AnimeAniListTitle: Codable {
        var native: String?,
            romaji: String?,
            english: String?
        
        init(native: String? = nil, romaji: String? = nil, english: String? = nil) {
            self.native = native
            self.romaji = romaji
            self.english = english
        }
    }
}
