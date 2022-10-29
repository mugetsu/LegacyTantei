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
            var count: Int?,
                total: Int?
            
            init(count: Int? = nil, total: Int? = nil) {
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
        var malId: Int?,
            images: AnimeImages?,
            titles: [AnimeTitle]?,
            airing: Bool?,
            aired: AnimeAired?,
            rating: String?,
            score: Decimal?,
            rank: Int?,
            popularity: Int?,
            favorites: Int?,
            synopsis: String?,
            background: String?,
            year: Int?,
            broadcast: AnimeBroadcast?,
            studios: [AnimeMetaData]?,
            genres: [AnimeMetaData]?,
            themes: [AnimeMetaData]?,
            demographics: [AnimeMetaData]?,
            trailer: AnimeTrailer?,
            type: String?,
            episodes: Int?
            
        private enum CodingKeys: String, CodingKey {
            case malId = "mal_id",
                 images, titles, airing, aired, rating, score, rank, popularity, favorites, synopsis, background, year, broadcast, studios, genres, themes, demographics, trailer, type, episodes

        }
        
        init(malId: Int? = nil, images: Jikan.AnimeImages? = nil, titles: [Jikan.AnimeTitle]? = nil, airing: Bool? = nil, aired: Jikan.AnimeAired? = nil, rating: String? = nil, score: Decimal? = nil, rank: Int? = nil, popularity: Int? = nil, favorites: Int? = nil, synopsis: String? = nil, background: String? = nil, year: Int? = nil, broadcast: AnimeBroadcast? = nil, studios: [Jikan.AnimeMetaData]? = nil, genres: [Jikan.AnimeMetaData]? = nil, themes: [Jikan.AnimeMetaData]? = nil, demographics: [Jikan.AnimeMetaData]? = nil, trailer: Jikan.AnimeTrailer? = nil, type: String? = nil, episodes: Int? = nil) {
            self.malId = malId
            self.images = images
            self.titles = titles
            self.airing = airing
            self.aired = aired
            self.rating = rating
            self.score = score
            self.rank = rank
            self.popularity = popularity
            self.favorites = favorites
            self.synopsis = synopsis
            self.background = background
            self.year = year
            self.broadcast = broadcast
            self.studios = studios
            self.genres = genres
            self.themes = themes
            self.demographics = demographics
            self.trailer = trailer
            self.type = type
            self.episodes = episodes
        }
    }
    
    struct AnimeImages: Codable {
        var webp: AnimeImageURL?
        
        init(webp: Jikan.AnimeImageURL? = nil) {
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
        var type: String?,
            title: String?
        
        init(type: String? = nil, title: String? = nil) {
            self.type = type
            self.title = title
        }
    }
    
    struct AnimeBroadcast: Codable {
        var day: String?,
            time: String?,
            timezone: String?,
            string: String?
        
        init(day: String? = nil, time: String? = nil, timezone: String? = nil, string: String? = nil) {
            self.day = day
            self.time = time
            self.timezone = timezone
            self.string = string
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
        var type: String?,
            name: String?
        
        init(type: String? = nil, name: String? = nil) {
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
    
    struct AnimeRelations: Codable {
        var relation: String?
        var entry: [AnimeEntry]?
        
        init(relation: String? = nil, entry: [Jikan.AnimeEntry]? = nil) {
            self.relation = relation
            self.entry = entry
        }
    }
    
    struct AnimeEntry: Codable {
        var malId: Int?
        var type: String?
        
        private enum CodingKeys: String, CodingKey {
            case malId = "mal_id", type
        }
        
        init(malId: Int? = nil, type: String? = nil) {
            self.malId = malId
            self.type = type
        }
    }
}
