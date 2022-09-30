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
        guard Reachability.isConnectedToNetwork(),
              var searchURL = URLComponents(string: Endpoint.search.url) else {
            completion(.failure(.notConnected))
            return
        }
        searchURL.queryItems = [
            URLQueryItem(name: "anilistInfo", value: ""),
            URLQueryItem(name: "url", value: url)
        ]
        guard let requestURL = searchURL.url else {
            completion(.failure(.other(reason: "No endpoint url")))
            return
        }
        let request = URLRequest(url: requestURL).processRequest()
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.other(reason: "\(error)")))
                return
            }
            guard let data = data else {
                completion(.failure(.other(reason: "No data")))
                return
            }
            do {
                let animes = try JSONDecoder().decode(Anime.self, from: data)
                guard animes.error == "" else {
                    completion(.failure(.other(reason: animes.error ?? "")))
                    return
                }
                let animeResult = animes.result ?? []
                let uniqueResult = animeResult.unique{ $0.anilist.id }
                completion(.success(uniqueResult))
            } catch let error {
                completion(.failure(.other(reason: "\(error)")))
            }
        }.resume()
    }
}
