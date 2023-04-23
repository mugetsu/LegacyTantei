//
//  TraceAPIRequest.swift
//  Tantei
//
//  Created by Randell on 6/11/22.
//

import Foundation

enum TraceAPIRequest {
    case searchAnimeByImageURL(url: String)
}

extension TraceAPIRequest: RequestProtocol {
    var path: String {
        switch self {
        case .searchAnimeByImageURL:
            return "/search"
        }
    }

    var method: RequestMethod {
        switch self {
        case .searchAnimeByImageURL:
            return .get
        }
    }

    var headers: ReaquestHeaders? {
        nil
    }

    var parameters: RequestParameters? {
        switch self {
        case let .searchAnimeByImageURL(url):
            return [
                "anilistInfo": "",
                "url": url
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

