//
//  Anime.swift
//  Tantei-san
//
//  Created by Randell on 10/10/22.
//

import Foundation

struct Anime {
    let imageURL: String,
        title: String,
        genres: [Genre],
        synopsis: String
    
    enum Genre: String {
        case action = "Action",
             comedy = "Comedy",
             horror = "Horror",
             sports = "Sports",
             adventure = "Adventure",
             drama = "Drama",
             mystery = "Mystery",
             supernatural = "Supernatural",
             avantGarde = "Avant Garde",
             fantasy = "Fantasy",
             romance = "Romance",
             suspense = "Suspense",
             awardWinning = "Award Winning",
             girlsLove = "Girls Love",
             sciFi = "Sci-Fi",
             boysLove = "Boys Love",
             gourmet = "Gourmet",
             sliceOfLife = "Slice of Life",
             ecchi = "Ecchi",
             erotica = "Erotica",
             hentai = "Hentai",
             others = ""
    }
}
