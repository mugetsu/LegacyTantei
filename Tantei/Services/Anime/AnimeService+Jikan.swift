//
//  AnimeService+Jikan.swift
//  Tantei
//
//  Created by Randell on 5/10/22.
//

import Foundation

extension AnimeService {
    
    static func getTopAnimes(type: SearchQueryType, filter: SearchFilterType, limit: Int, completion: @escaping (Result<[Jikan.AnimeDetails], AnimeError>) -> Void) {
        if self.isMocked {
            if let url = Bundle.main.url(forResource: "get-top-animes", withExtension: "json") {
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
                URLQueryItem(name: "filter", value: filter.rawValue),
                URLQueryItem(name: "limit", value: String(limit))
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
                    guard let animeResult = animes.data else {
                        completion(.failure(.other(reason: "No data")))
                        return
                    }
                    completion(.success(animeResult))
                } catch let error {
                    completion(.failure(.other(reason: "\(error)")))
                }
            }.resume()
        }
    }
    
    static func getAnimeRelations(id: Int, completion: @escaping (Result<[Jikan.AnimeRelations], AnimeError>) -> Void) {
        if self.isMocked {
            if let url = Bundle.main.url(forResource: "get-relations", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Jikan.Anime<[Jikan.AnimeRelations]>.self, from: data)
                    guard let data = response.data else { return }
                    completion(.success(data))
                } catch {
                    completion(.failure(.other(reason: "\(error)")))
                }
            } else {
                completion(.failure(.other(reason: "Mock for JSON file not found")))
            }
        } else {
            guard Reachability.isConnectedToNetwork(),
                  let relationsURL = URLComponents(string: Endpoint.getRelations(.jikan, id: id).url) else {
                completion(.failure(.notConnected))
                return
            }
            guard let requestURL = relationsURL.url else {
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
                    completion(.failure(.other(reason: "getAnimeRelations No data")))
                    return
                }
                do {
                    let relations = try JSONDecoder().decode(Jikan.Anime<[Jikan.AnimeRelations]>.self, from: data)
                    guard relations.error == nil else {
                        completion(.failure(.other(reason: relations.error ?? "")))
                        return
                    }
                    let relationsResult = relations.data ?? []
                    completion(.success(relationsResult))
                } catch let error {
                    completion(.failure(.other(reason: "\(error)")))
                }
            }.resume()
        }
    }
    
    static func getAnimeBy(id: Int, completion: @escaping (Result<Jikan.AnimeDetails, AnimeError>) -> Void) {
        if self.isMocked {
            if let url = Bundle.main.url(forResource: "get-anime-by-id", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Jikan.Anime<Jikan.AnimeDetails>.self, from: data)
                    guard let data = response.data else { return }
                    completion(.success(data))
                } catch {
                    completion(.failure(.other(reason: "\(error)")))
                }
            } else {
                completion(.failure(.other(reason: "Mock for JSON file not found")))
            }
        } else {
            guard Reachability.isConnectedToNetwork(),
                  let animeURL = URLComponents(string: Endpoint.getAnimeBy(.jikan, id: id).url) else {
                completion(.failure(.notConnected))
                return
            }
            guard let requestURL = animeURL.url else {
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
                    let animes = try JSONDecoder().decode(Jikan.Anime<Jikan.AnimeDetails>.self, from: data)
                    guard animes.error == nil else {
                        completion(.failure(.other(reason: animes.error ?? "")))
                        return
                    }
                    guard let animeResult = animes.data else {
                        completion(.failure(.other(reason: "getAnimeBy \(id) No data")))
                        return
                    }
                    completion(.success(animeResult))
                } catch let error {
                    completion(.failure(.other(reason: "\(error)")))
                }
            }.resume()
        }
    }
    
    static func searchAnimeByTitle(using keyword: String, completion: @escaping (Result<Jikan.AnimeDetails, AnimeError>) -> Void) {
        if self.isMocked {
            if let url = Bundle.main.url(forResource: "search-anime-by-title", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Jikan.Anime<[Jikan.AnimeDetails]>.self, from: data)
                    guard let data = response.data?.first else { return }
                    completion(.success(data))
                } catch {
                    completion(.failure(.other(reason: "\(error)")))
                }
            } else {
                completion(.failure(.other(reason: "Mock for JSON file not found")))
            }
        } else {
            guard Reachability.isConnectedToNetwork(),
                  var searchURL = URLComponents(string: Endpoint.search(.jikan).url) else {
                completion(.failure(.notConnected))
                return
            }
            searchURL.queryItems = [
                URLQueryItem(name: "letter", value: keyword),
                URLQueryItem(name: "limit", value: "1")
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
                    let animes = try JSONDecoder().decode(Jikan.Anime<[Jikan.AnimeDetails]>.self, from: data)
                    guard animes.error == nil else {
                        completion(.failure(.other(reason: animes.error ?? "")))
                        return
                    }
                    guard let animeResult = animes.data?.first else {
                        completion(.failure(.other(reason: "searchAnimeByTitle \(keyword) No data")))
                        return
                    }
                    completion(.success(animeResult))
                } catch let error {
                    completion(.failure(.other(reason: "\(error)")))
                }
            }.resume()
        }
    }

}
