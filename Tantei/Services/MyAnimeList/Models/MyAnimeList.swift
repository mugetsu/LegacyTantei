//
//  MyAnimeList.swift
//  Tantei
//
//  Created by Randell Quitain on 1/4/23.
//

import Foundation

struct MyAnimeList {
    struct Base<R: Codable>: Codable {
        var data: R?,
            paging: Paging?,
            message: String?,
            error: String?
        
        init(data: R? = nil, paging: MyAnimeList.Paging? = nil, message: String? = nil, error: String? = nil) {
            self.data = data
            self.paging = paging
            self.message = message
            self.error = error
        }
    }
    
    struct Paging: Codable {
        var previous: String?,
            next: String?
        
        init(previous: String? = nil, next: String? = nil) {
            self.previous = previous
            self.next = next
        }
    }
    
    struct AnimeNode: Codable {
        var node: AnimeDetails,
            ranking: Ranking?
        
        struct Ranking: Codable {
            var rank: Int
        }
        
        init(node: MyAnimeList.AnimeDetails, ranking: Ranking? = nil) {
            self.node = node
            self.ranking = ranking
        }
    }
    
    struct AnimeDetails: Codable {
        var id: Int,
            title: String,
            mainPicture: AnimeImage?,
            synopsis: String?,
            rating: String?,
            genres: [AnimeMetaData]?
        
        private enum CodingKeys: String, CodingKey {
            case mainPicture = "main_picture",
                 id, title, synopsis, rating, genres
        }
        
        init(id: Int, title: String, mainPicture: AnimeImage? = nil, synopsis: String? = nil, rating: String? = nil, genres: [AnimeMetaData]? = nil) {
            self.id = id
            self.title = title
            self.mainPicture = mainPicture
            self.synopsis = synopsis
            self.rating = rating
            self.genres = genres
        }
    }
    
    struct AnimeMetaData: Codable {
        var id: Int?,
            name: String?
        
        init(id: Int? = nil, name: String? = nil) {
            self.id = id
            self.name = name
        }
    }
    
    struct AnimeImage: Codable {
        var medium: String?,
            large: String?
        
        init(medium: String? = nil, large: String? = nil) {
            self.medium = medium
            self.large = large
        }
    }
}
