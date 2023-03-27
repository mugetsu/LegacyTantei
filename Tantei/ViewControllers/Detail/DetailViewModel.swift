//
//  DetailViewModel.swift
//  Tantei
//
//  Created by Randell on 10/11/22.
//

import Combine
import Foundation

final class DetailViewModel {
    var detail: Anime
    
    init(detail: Anime) {
        self.detail = detail
    }
    
    private var viewModelEvent = PassthroughSubject<DetailEvents.ViewModelEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let jikan = JikanAPI()
    
    func bind(_ uiEvents: AnyPublisher<DetailEvents.UIEvent, Never>) -> AnyPublisher<DetailEvents.ViewModelEvent, Never> {
        uiEvents.sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .viewDidLoad:
                self.fetchData()
            }
        }.store(in: &cancellables)
        return viewModelEvent.eraseToAnyPublisher()
    }
    
    private func fetchData() {
        Task {
            do {
                async let episodes = try await jikan.getEpisodes(id: detail.malId, page: 1)
                async let news = try await jikan.getNews(id: detail.malId, page: 1)
                let latestEpisodes = try await episodes ?? []
                let latestNews = try await news ?? []
                viewModelEvent.send(
                    .fetchSuccess(
                        detail: detail,
                        episodes: getEpisodesForDisplay(latestEpisodes),
                        news: latestNews
                    )
                )
            } catch {
                viewModelEvent.send(.fetchFailed)
            }
        }
    }
    
    private func getEpisodesForDisplay(_ episodes: [Jikan.AnimeEpisode]) -> [Jikan.AnimeEpisode] {
        let maxEpisodesForDisplay = 5
        let episodesCount = episodes.count
        let episodesForDisplay = episodesCount >= maxEpisodesForDisplay
            ? maxEpisodesForDisplay
            : episodesCount
        return Array(episodes[(episodesCount - episodesForDisplay)..<episodesCount]).reversed()
    }
}

enum DetailEvents {
    enum UIEvent {
        case viewDidLoad
    }
    
    enum ViewModelEvent {
        case fetchSuccess(detail: Anime, episodes: [Jikan.AnimeEpisode], news: [Jikan.AnimeNews])
        case fetchFailed
    }
}
