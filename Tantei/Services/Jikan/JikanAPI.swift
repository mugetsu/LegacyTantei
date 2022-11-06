//
//  JikanAPI.swift
//  Tantei
//
//  Created by Randell on 5/10/22.
//

import Foundation

final class JikanAPI: JikanAPIProtocol {
    private let apiRequest: APIRequestProtocol

    init(apiRequest: APIRequestProtocol = APIRequest()) {
        self.apiRequest = apiRequest
    }
    
    func getScheduleToday(filter: String, limit: Int) async throws -> [Jikan.AnimeDetails]? {
        if APIEnvironment.jikan.isMocked {
            if let url = Bundle.main.url(forResource: "get-schedules", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Jikan.Anime<[Jikan.AnimeDetails]>.self, from: data)
                    guard let data = response.data else {
                        throw JikanError.nilData
                    }
                    return data
                } catch {
                    throw JikanError.other(reason: "\(error)")
                }
            } else {
                throw JikanError.other(reason: "Mock JSON file not found")
            }
        } else {
            let request = JikanAPIRequest.getSchedules(filter: filter, limit: limit)
            guard let requestURL = request.urlRequest(with: .jikan) else {
                throw JikanError.nilRequest
            }
            let apiData = try await apiRequest.get(request: requestURL)
            switch apiData {
            case .failure(let error):
                throw error
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let animes = try decoder.decode(Jikan.Anime<[Jikan.AnimeDetails]>.self, from: data)
                    guard animes.error == nil else {
                        throw JikanError.other(reason: animes.error ?? "")
                    }
                    guard let animeResult = animes.data else {
                        throw JikanError.nilData
                    }
                    return animeResult
                } catch {
                    throw JikanError.invalidResponseFormat
                }
            }
        }
    }
    
    func getTopAnimes(type: Jikan.AnimeType, filter: Jikan.TopAnimeType, limit: Int) async throws -> [Jikan.AnimeDetails]? {
        if APIEnvironment.jikan.isMocked {
            var mockResource: String = ""
            switch filter {
            case .airing:
                mockResource = "get-top-airing-animes"
            case .upcoming:
                mockResource = "get-top-upcoming-animes"
            case .popular:
                mockResource = "get-top-popular-animes"
            case .favorite:
                mockResource = "get-top-favorite-animes"
            }
            if let url = Bundle.main.url(forResource: mockResource, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Jikan.Anime<[Jikan.AnimeDetails]>.self, from: data)
                    guard let data = response.data else {
                        throw JikanError.nilData
                    }
                    return data
                } catch {
                    throw JikanError.other(reason: "\(error)")
                }
            } else {
                throw JikanError.other(reason: "Mock JSON file not found")
            }
        } else {
            let request = JikanAPIRequest.topAnime(
                type: type,
                filter: filter,
                limit: limit
            )
            guard let requestURL = request.urlRequest(with: .jikan) else {
                throw JikanError.nilRequest
            }
            let apiData = try await apiRequest.get(request: requestURL)
            switch apiData {
            case .failure(let error):
                throw error
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let animes = try decoder.decode(Jikan.Anime<[Jikan.AnimeDetails]>.self, from: data)
                    guard animes.error == nil else {
                        throw JikanError.other(reason: animes.error ?? "")
                    }
                    guard let animeResult = animes.data else {
                        throw JikanError.nilData
                    }
                    return animeResult
                } catch {
                    throw JikanError.invalidResponseFormat
                }
            }
        }
    }
    
    func searchAnimeByTitle(using keyword: String) async throws -> Jikan.AnimeDetails? {
        if APIEnvironment.jikan.isMocked {
            if let url = Bundle.main.url(forResource: "search-anime-by-title", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Jikan.Anime<[Jikan.AnimeDetails]>.self, from: data)
                    guard let data = response.data?.first else {
                        throw JikanError.nilData
                    }
                    return data
                } catch {
                    throw JikanError.other(reason: "\(error)")
                }
            } else {
                throw JikanError.other(reason: "Mock JSON file not found")
            }
        } else {
            let request = JikanAPIRequest.searchAnimeByTitle(keyword: keyword)
            guard let requestURL = request.urlRequest(with: .jikan) else {
                throw JikanError.nilRequest
            }
            let apiData = try await apiRequest.get(request: requestURL)
            switch apiData {
            case .failure(let error):
                throw error
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let animes = try decoder.decode(Jikan.Anime<[Jikan.AnimeDetails]>.self, from: data)
                    guard animes.error == nil else {
                        throw JikanError.other(reason: animes.error ?? "")
                    }
                    guard let animeResult = animes.data?.first else {
                        throw JikanError.nilData
                    }
                    return animeResult
                } catch {
                    throw JikanError.invalidResponseFormat
                }
            }
        }
    }

}
