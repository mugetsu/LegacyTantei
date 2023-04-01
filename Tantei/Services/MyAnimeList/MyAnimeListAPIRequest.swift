//
//  MyAnimeListAPIRequest.swift
//  Tantei
//
//  Created by Randell Quitain on 1/4/23.
//

import Foundation

enum MyAnimeListAPIRequest {
    case getTopAnimes(filter: MyAnimeList.TopAnimeType, limit: Int)
}

extension MyAnimeListAPIRequest: RequestProtocol {
    var path: String {
        switch self {
        case .getTopAnimes:
            return "/anime/ranking"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .getTopAnimes:
            return .get
        }
    }

    var headers: ReaquestHeaders? {
        return [
            "X-MAL-CLIENT-ID": Configuration.malKey
        ]
    }

    var parameters: RequestParameters? {
        switch self {
        case let .getTopAnimes(filter, limit):
            return [
                "ranking_type": filter.rawValue,
                "limit": String(limit),
                "fields": "synopsis,rating,genres"
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
