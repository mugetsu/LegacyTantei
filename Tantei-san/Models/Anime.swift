//
//  Anime.swift
//  Tantei-san
//
//  Created by Randell on 28/9/22.
//

import Foundation

struct Anime: Codable {
    var frameCount: Int
    var error: String
    var result: [AnimeResult]
}

struct AnimeResult: Codable {
    var anilist: AnimeAniList
    var filename: String
    var image: String
}

struct AnimeAniList: Codable {
    var id: Int
    var idMal: Int
    var title: AnimeAniListTitle
    var synonyms: [String]
    var isAdult: Bool
}

struct AnimeAniListTitle: Codable {
    var native: String
    var romaji: String
    var english: String
}
