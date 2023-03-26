//
//  JikanAPIRequest.swift
//  Tantei
//
//  Created by Randell on 5/11/22.
//

import Foundation

enum JikanAPIRequest {
    case getAnimeBy(id: Int),
         getEpisodesBy(id: Int, page: Int),
         getRelations(id: Int),
         getSchedules(filter: String),
         getTopAnime(type: Jikan.AnimeType, filter: Jikan.TopAnimeType, limit: Int),
         searchAnimeByTitle(keyword: String)
}

extension JikanAPIRequest: RequestProtocol {
    var path: String {
        switch self {
        case let .getAnimeBy(id):
            return "/anime/\(id)"
        case let .getEpisodesBy(id, _):
            return "/anime/\(id)/episodes"
        case let .getRelations(id):
            return "/anime/\(id)/relations"
        case .getSchedules:
            return "/schedules"
        case .getTopAnime:
            return "/top/anime"
        case .searchAnimeByTitle:
            return "/anime"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getAnimeBy:
            return .get
        case .getEpisodesBy:
            return .get
        case .getRelations:
            return .get
        case .getSchedules:
            return .get
        case .getTopAnime:
            return .get
        case .searchAnimeByTitle:
            return .get
        }
    }

    var headers: ReaquestHeaders? {
        nil
    }

    var parameters: RequestParameters? {
        switch self {
        case .getAnimeBy:
            return nil
        case let .getEpisodesBy(_, page):
            return [
                "page": String(page)
            ]
        case .getRelations:
            return nil
        case let .getSchedules(filter):
            return [
                "filter": filter,
                "kids": "false"
            ]
        case let .getTopAnime(type, filter, limit):
            return [
                "type": type.rawValue,
                "filter": filter.rawValue,
                "limit": String(limit)
            ]
        case let .searchAnimeByTitle(keyword):
            return [
                "letter": keyword,
                "limit": "1"
            ]
        }
    }

    var requestType: RequestType {
        return .data
    }

    var responseType: ResponseType {
        return .json
    }
}
