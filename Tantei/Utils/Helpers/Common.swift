//
//  Common.swift
//  Tantei
//
//  Created by Randell on 31/10/22.
//

import Foundation

class Common {
    static func trimSynopsis(from synopsis: String) -> String {
        let cleanSynopsis = synopsis
            .replacingOccurrences(
                of: "\\(Source:.*\\)|\\[Written.*\\]",
                with: "",
                options: .regularExpression,
                range: nil
            )
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        return cleanSynopsis
    }
    
    static func createAnimeModel(with anime: Jikan.AnimeDetails) -> Anime {
        var model: Anime = .init(
            malId: 0,
            thumbnailURL: "",
            imageURL: "",
            title: "",
            rating: .g,
            score: 0,
            genres: [],
            synopsis: ""
        )
        guard let malId = anime.malId,
              let thumbnailURL = anime.images?.webp?.regular,
              let imageURL = anime.images?.webp?.large,
              let title = anime.title,
              let rating = Anime.Rating(rawValue: anime.rating ?? ""),
              let score = anime.score,
              let relativeGenre = anime.genres
        else {
            return model
        }
        let genres = relativeGenre.map { genre -> Anime.Genre in
            guard let name = Anime.Genre(rawValue: genre.name ?? "") else {
                return .others
            }
            return name
        }
        let synopsis = trimSynopsis(from: anime.synopsis ?? "")
        model = Anime(
            malId: malId,
            thumbnailURL: thumbnailURL,
            imageURL: imageURL,
            title: title,
            rating: rating,
            score: score,
            genres: genres,
            synopsis: synopsis
        )
        return model
    }
}
