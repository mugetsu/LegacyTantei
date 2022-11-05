//
//  TraceAPI.swift
//  Tantei
//
//  Created by Randell on 1/10/22.
//

import Foundation

final class TraceAPI: TraceAPIProtocol {
    private let apiRequest: APIRequestProtocol

    init(apiRequest: APIRequestProtocol = APIRequest()) {
        self.apiRequest = apiRequest
    }

    func searchAnimeByURL(url: String) async throws -> [Trace.AnimeDetails] {
        if APIEnvironment.trace.isMocked {
            if let url = Bundle.main.url(forResource: "search-by-url", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Trace.Anime.self, from: data)
                    guard let data = response.result else {
                        throw TraceError.nilData
                    }
                    return data
                } catch {
                    throw TraceError.other(reason: "\(error)")
                }
            } else {
                throw TraceError.other(reason: "Mock JSON file not found")
            }
        } else {
            let request = TraceAPIRequest.searchAnimeByImageURL(url: url)
            guard let requestURL = request.urlRequest(with: .trace) else {
                throw TraceError.nilRequest
            }
            let apiData = try await apiRequest.get(request: requestURL)
            switch apiData {
            case .failure(let error):
                throw error
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(Trace.Anime.self, from: data)
                    guard response.error == "" else {
                        throw TraceError.other(reason: response.error ?? "Trace error")
                    }
                    guard let animeResult = response.result else {
                        throw TraceError.nilData
                    }
                    let uniqueResult = animeResult.unique { $0.anilist?.id }
                    let sorted = uniqueResult.sorted(by: {
                        ($0.similarity ?? 0) > ($1.similarity ?? 0)
                    })
                    return sorted
                } catch {
                    throw TraceError.invalidResponseFormat
                }
            }
        }
    }
}
