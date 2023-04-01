//
//  MyAnimeListAPI.swift
//  Tantei
//
//  Created by Randell Quitain on 1/4/23.
//

import Foundation

final class MyAnimeListAPI: MyAnimeListAPIProtocol {
    private let apiRequest: APIRequestProtocol

    init(apiRequest: APIRequestProtocol = APIRequest()) {
        self.apiRequest = apiRequest
    }
    
    func getTopAnimes(filter: MyAnimeList.TopAnimeType, limit: Int) async throws -> [MyAnimeList.AnimeNode]? {
        if APIEnvironment.jikan.isMocked {
            var mockResource: String = ""
            switch filter {
            case .airing:
                mockResource = "get-top-airing-animes-mal"
            default:
                throw MyAnimeListError.other(reason: "Mock JSON file not found")
            }
            if let url = Bundle.main.url(forResource: mockResource, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(MyAnimeList.Base<[MyAnimeList.AnimeNode]>.self, from: data)
                    guard let data = response.data else {
                        throw MyAnimeListError.nilData
                    }
                    return data
                } catch {
                    throw MyAnimeListError.other(reason: "\(error)")
                }
            } else {
                throw MyAnimeListError.other(reason: "Mock JSON file not found")
            }
        } else {
            let request = MyAnimeListAPIRequest.getTopAnimes(
                filter: filter,
                limit: limit
            )
            guard let requestURL = request.urlRequest(with: .mal) else {
                throw MyAnimeListError.nilRequest
            }
            let apiData = try await apiRequest.get(request: requestURL)
            switch apiData {
            case .failure(let error):
                throw error
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let animes = try decoder.decode(MyAnimeList.Base<[MyAnimeList.AnimeNode]>.self, from: data)
                    guard animes.error == nil else {
                        throw MyAnimeListError.other(reason: animes.error ?? "")
                    }
                    guard let animeResult = animes.data else {
                        throw MyAnimeListError.nilData
                    }
                    return animeResult
                } catch {
                    throw MyAnimeListError.invalidResponseFormat
                }
            }
        }
    }
}
