//
//  AnimeService.swift
//  Tantei-san
//
//  Created by Randell on 28/9/22.
//

import Foundation
import Alamofire

final class AnimeService {
    
    private enum API {
        case base
        
        var url: String {
            switch self {
            case .base:
                return "https://api.trace.moe"
            }
        }
    }
    
    private enum Endpoint {
        case search
        
        var path: String {
            switch self {
            case .search:
                return "/search"
            }
        }
        
        var url: String {
            switch self {
            case .search:
                return "\(API.base.url)\(path)"
            }
        }
    }
    
    static func getAnimeByURL(url: String, completion: @escaping (Result<[AnimeResult], AnimeError>) -> Void) {
        let parameters: [String: String] = [
            "anilistInfo": "",
            "url": url
        ]
        AF.request(Endpoint.search.url, parameters: parameters)
            .validate()
            .responseDecodable(of: Anime.self) { response in
                let result = response.result
                switch result {
                case .failure(let error):
                    if let underlyingError = error.asAFError?.underlyingError {
                        if let urlError = underlyingError as? URLError {
                            switch urlError.code {
                            case .timedOut:
                                completion(.failure(.timeOut))
                            case .notConnectedToInternet:
                                completion(.failure(.notConnected))
                            default:
                                completion(.failure(.other))
                            }
                        }
                    }
                case .success(let value):
                    if value.error.isEmpty {
                        let uniqueResult = value.result.unique{ $0.anilist.id }
                        completion(.success(uniqueResult))
                    } else {
                        completion(.failure(.exceededLimit))
                    }
                }
            }
    }
}
