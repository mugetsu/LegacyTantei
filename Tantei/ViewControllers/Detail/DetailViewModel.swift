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
                let latestEpisodes = try await episodes ?? []
                let episodesCount = latestEpisodes.count
                let lastEpisodes: [Jikan.AnimeEpisode] = Array(latestEpisodes[(episodesCount - (episodesCount >= 9 ? 9 : episodesCount))..<episodesCount]).reversed()
                viewModelEvent.send(
                    .fetchSuccess(
                        detail: detail,
                        episodes: lastEpisodes
                    )
                )
            } catch {
                viewModelEvent.send(.fetchFailed)
            }
        }
    }
}

enum DetailEvents {
    enum UIEvent {
        case viewDidLoad
    }
    
    enum ViewModelEvent {
        case fetchSuccess(detail: Anime, episodes: [Jikan.AnimeEpisode])
        case fetchFailed
    }
}
