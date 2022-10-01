//
//  AnimeService+Trace.swift
//  Tantei-san
//
//  Created by Randell on 1/10/22.
//

import Foundation

extension AnimeService {
    
    static func getAnimeByURL(url: String, completion: @escaping (Result<[Trace.AnimeResult], AnimeError>) -> Void) {
        if self.isMocked {
            do {
                completion(.success(MockData.animeByURL))
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
                    completion(.success(uniqueResult))
                } catch let error {
                    completion(.failure(.other(reason: "\(error)")))
                }
            }.resume()
        }
    }
}
