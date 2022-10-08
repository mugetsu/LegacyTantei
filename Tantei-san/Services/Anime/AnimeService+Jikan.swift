//
//  AnimeService+Jikan.swift
//  Tantei-san
//
//  Created by Randell on 5/10/22.
//

import Foundation

extension AnimeService {
    
    static func getTopAnime(type: SearchQueryType, filter: SearchFilterType, completion: @escaping (Result<[Jikan.AnimeDetails], AnimeError>) -> Void) {
        if self.isMocked {
            if let url = Bundle.main.url(forResource: "get-top-anime", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Jikan.Anime<[Jikan.AnimeDetails]>.self, from: data)
                    guard let data = response.data else { return }
                    completion(.success(data))
                } catch {
                    completion(.failure(.other(reason: "\(error)")))
                }
            } else {
                completion(.failure(.other(reason: "Mock JSON file not found")))
            }
        } else {
            guard Reachability.isConnectedToNetwork(),
                  var topAnimeURL = URLComponents(string: Endpoint.topAnime(.jikan).url) else {
                completion(.failure(.notConnected))
                return
            }
            topAnimeURL.queryItems = [
                URLQueryItem(name: "type", value: type.rawValue),
                URLQueryItem(name: "filter", value: filter.rawValue)
            ]
            guard let requestURL = topAnimeURL.url else {
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
                    let animes = try JSONDecoder().decode(Jikan.Anime<[Jikan.AnimeDetails]>.self, from: data)
                    guard animes.error == nil else {
                        completion(.failure(.other(reason: animes.error ?? "")))
                        return
                    }
                    let animeResult = animes.data ?? []
                    completion(.success(animeResult))
                } catch let error {
                    completion(.failure(.other(reason: "\(error)")))
                }
            }.resume()
        }
    }
}
