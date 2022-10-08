//
//  AnimeService+Trace.swift
//  Tantei-san
//
//  Created by Randell on 1/10/22.
//

import Foundation

extension AnimeService {
    
    static func getAnimeByURL(url: String, completion: @escaping (Result<[Trace.AnimeDetails], AnimeError>) -> Void) {
        if self.isMocked {
            if let url = Bundle.main.url(forResource: "search-by-url", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Trace.Anime.self, from: data)
                    let animeResult = response.result ?? []
                    let uniqueResult = animeResult.unique{ $0.anilist.id }
                    let sorted = uniqueResult.sorted(by: { ($0.similarity ?? 0) > ($1.similarity ?? 0) })
                    completion(.success(sorted))
                } catch {
                    completion(.failure(.other(reason: "\(error)")))
                }
            } else {
                completion(.failure(.other(reason: "Mock JSON file not found")))
            }
        } else {
            guard Reachability.isConnectedToNetwork(),
                  var searchURL = URLComponents(string: Endpoint.searchByURL(.trace).url) else {
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
                    let animes = try JSONDecoder().decode(Trace.Anime.self, from: data)
                    guard animes.error == "" else {
                        completion(.failure(.other(reason: animes.error ?? "")))
                        return
                    }
                    let animeResult = animes.result ?? []
                    let uniqueResult = animeResult.unique{ $0.anilist.id }
                    let sorted = uniqueResult.sorted(by: { ($0.similarity ?? 0) > ($1.similarity ?? 0) })
                    completion(.success(sorted))
                } catch let error {
                    completion(.failure(.other(reason: "\(error)")))
                }
            }.resume()
        }
    }
}
