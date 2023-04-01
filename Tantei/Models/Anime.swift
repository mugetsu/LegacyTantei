//
//  Anime.swift
//  Tantei
//
//  Created by Randell on 10/10/22.
//

import Foundation
import UIKit

struct Anime {
    let malId: Int,
        thumbnailURL: String,
        imageURL: String,
        title: String,
        rating: Rating,
        score: Double,
        genres: [Genre],
        synopsis: String
    
    enum Rating: String {
        case g = "g",
             pg = "pg",
             pg13 = "pg_13",
             r17 = "r_17",
             r = "r",
             rx = "rx"
         
        var tag: String {
            switch self {
            case .g: return "G"
            case .pg: return "PG"
            case .pg13: return "PG-13"
            case .r17: return "R-17"
            case .r: return "R"
            case .rx: return "RX"
            }
        }
        
        var color: UIColor {
            switch self {
            case .g: return UIColor("#2cb67d")
            case .pg: return UIColor("#3da9fc")
            case .pg13: return UIColor("#ffd803")
            case .r17: return UIColor("#ff8906")
            case .r: return UIColor("#ef4565")
            case .rx: return UIColor("#ef4565")
            }
        }
    }
    
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
