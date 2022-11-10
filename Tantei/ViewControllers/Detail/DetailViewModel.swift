//
//  DetailViewModel.swift
//  Tantei
//
//  Created by Randell on 10/11/22.
//

import Foundation

final class DetailViewModel {
    private var state: ViewState {
        didSet {
            self.delegate?.didUpdate(with: state)
        }
    }
    
    private var jikan: JikanAPI = JikanAPI()
    
    private var anime: Anime
    
    private var episodes: [Jikan.AnimeEpisode] = []
    
    weak var delegate: RequestDelegate?
    
    init(anime: Anime) {
        self.anime = anime
        self.state = .idle
    }
}

// MARK: DataSource
extension DetailViewModel {
    func fetchData() {
        Task {
            do {
                state = .loading
                async let animeEpisodes = getAnimeEpisode(with: anime.malId)
                episodes = try await animeEpisodes
                state = .success
            } catch {
                state = .error(error)
            }
        }
    }
    
    func getAnimeDetail() -> Anime {
        return anime
    }
}

// MARK: Services
extension DetailViewModel {
    func getAnimeEpisode(with id: Int) async throws -> [Jikan.AnimeEpisode] {
        do {
            let episodes = try await jikan.getEpisodes(with: id)
            return episodes ?? []
        } catch {
            throw error
        }
    }
}
