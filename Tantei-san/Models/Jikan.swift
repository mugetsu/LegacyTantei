//
//  Jikan.swift
//  Tantei-san
//
//  Created by Randell on 5/10/22.
//

import Foundation

struct Jikan {
    
    struct Anime<R: Codable>: Codable {
        var message: String?,
            error: String?,
            pagination: Pagination?,
            data: R?
        
        init(message: String? = nil, error: String? = nil, pagination: Jikan.Pagination? = nil, data: R? = nil) {
            self.message = message
            self.error = error
            self.pagination = pagination
            self.data = data
        }
    }
    
    struct Pagination: Codable {
        var lastPage: Int?,
            hasNextPage: Bool?,
            currentPage: Int?,
            items: Items?
        
        struct Items: Codable {
            let count: Int,
                total: Int
            
            init(count: Int, total: Int) {
                self.count = count
                self.total = total
            }
        }
        
        private enum CodingKeys: String, CodingKey {
            case lastPage = "last_visible_page",
                 hasNextPage = "has_next_page",
                 currentPage = "current_page",
                 items
        }
        
        init(lastPage: Int? = nil, hasNextPage: Bool? = nil, currentPage: Int? = nil, items: Jikan.Pagination.Items? = nil) {
            self.lastPage = lastPage
            self.hasNextPage = hasNextPage
            self.currentPage = currentPage
            self.items = items
        }
    }
    
    struct AnimeDetails: Codable {
        let malId: Int,
            images: AnimeImages,
            titles: [AnimeTitle],
            airing: Bool,
            aired: AnimeAired,
            score: Decimal,
            rank: Int,
            popularity: Int,
            favorites: Int,
            synopsis: String,
            studios: [AnimeMetaData],
            genres: [AnimeMetaData],
            themes: [AnimeMetaData],
            demographics: [AnimeMetaData]
        var trailer: AnimeTrailer?,
            type: String?,
            episodes: Int?,
            rating: String?,
            year: Int?
        
        private enum CodingKeys: String, CodingKey {
            case malId = "mal_id",
                 images,
                 titles,
                 airing,
                 aired,
                 score,
                 rank,
                 popularity,
                 favorites,
                 synopsis,
                 studios,
                 genres,
                 themes,
                 demographics,
                 trailer,
                 type,
                 episodes,
                 rating,
                 year
        }
        
        init(malId: Int, images: Jikan.AnimeImages, titles: [Jikan.AnimeTitle], airing: Bool, aired: Jikan.AnimeAired, score: Decimal, rank: Int, popularity: Int, favorites: Int, synopsis: String, studios: [Jikan.AnimeMetaData], genres: [Jikan.AnimeMetaData], themes: [Jikan.AnimeMetaData], demographics: [Jikan.AnimeMetaData], trailer: Jikan.AnimeTrailer? = nil, type: String? = nil, episodes: Int? = nil, rating: String? = nil, year: Int? = nil) {
            self.malId = malId
            self.images = images
            self.titles = titles
            self.airing = airing
            self.aired = aired
            self.score = score
            self.rank = rank
            self.popularity = popularity
            self.favorites = favorites
            self.synopsis = synopsis
            self.studios = studios
            self.genres = genres
            self.themes = themes
            self.demographics = demographics
            self.trailer = trailer
            self.type = type
            self.episodes = episodes
            self.rating = rating
            self.year = year
        }
    }
    
    struct AnimeImages: Codable {
        let webp: AnimeImageURL
        
        init(webp: Jikan.AnimeImageURL) {
            self.webp = webp
        }
    }
    
    struct AnimeImageURL: Codable {
        var regular: String?,
            small: String?,
            medium: String?,
            large: String?,
            max: String?
        
        private enum CodingKeys: String, CodingKey {
            case regular = "image_url",
                 small = "small_image_url",
                 medium = "medium_image_url",
                 large = "large_image_url",
                 max = "maximum_image_url"
        }
        
        init(regular: String? = nil, small: String? = nil, medium: String? = nil, large: String? = nil, max: String? = nil) {
            self.regular = regular
            self.small = small
            self.medium = medium
            self.large = large
            self.max = max
        }
    }
    
    struct AnimeTitle: Codable {
        let type: String,
            title: String
        
        init(type: String, title: String) {
            self.type = type
            self.title = title
        }
    }
    
    struct AnimeAired: Codable {
        var from: String?,
            to: String?
        
        init(from: String? = nil, to: String? = nil) {
            self.from = from
            self.to = to
        }
    }
    
    struct AnimeMetaData: Codable {
        let type: String,
            name: String
        
        init(type: String, name: String) {
            self.type = type
            self.name = name
        }
    }
    
    struct AnimeTrailer: Codable {
        var embedURL: String?,
            images: AnimeImageURL?
        
        private enum CodingKeys: String, CodingKey {
            case embedURL = "embed_url",
                 images
        }
        
        init(embedURL: String? = nil, images: Jikan.AnimeImageURL? = nil) {
            self.embedURL = embedURL
            self.images = images
        }
    }
}
