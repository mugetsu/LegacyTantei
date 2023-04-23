//
//  DashboardViewModel.swift
//  Tantei
//
//  Created by Randell on 1/10/22.
//

import Combine
import Foundation

final class DashboardViewModel {
    private var viewModelEvent = PassthroughSubject<DashboardEvents.ViewModelEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var currentContext = LocalContext.shared
    private let jikan = JikanAPI()
    private var topAnimes: [Jikan.AnimeDetails] = []
    private var scheduledAnimesForToday: [Jikan.AnimeDetails] = []
    
    func bind(_ uiEvents: AnyPublisher<DashboardEvents.UIEvent, Never>) -> AnyPublisher<DashboardEvents.ViewModelEvent, Never> {
        uiEvents.sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .viewDidLoad:
                self.fetchData()
            case let .getAnimeDetails(index):
                let anime = Common.createAnimeModel(with: self.topAnimes[index])
                self.viewModelEvent.send(.showAnimeDetails(anime))
            case let .changedCategory(category):
                Task {
                    self.showUpdatedTopAnimes(category)
                }
            }
        }.store(in: &cancellables)
        return viewModelEvent.eraseToAnyPublisher()
    }
    
    private func fetchData() {
        topAnimes = currentContext.topAnimes
        scheduledAnimesForToday = currentContext.scheduledAnimesForToday
        viewModelEvent.send(
            .fetchSuccess(
                topAnimes,
                scheduledAnimesForToday
            )
        )
    }
    
    private func showUpdatedTopAnimes(_ category: Jikan.TopAnimeType) {
        Task {
            do {
                let defaultTopAnimes = try await jikan.getTopAnimes(
                    type: .tv,
                    filter: category,
                    limit: 10
                )
                let updatedTopAnimes = try await checkIfHasLazySynopsis(
                    from: defaultTopAnimes ?? []
                )
                topAnimes = updatedTopAnimes
                viewModelEvent.send(.showUpdatedTopAnimes(topAnimes))
            } catch {
                viewModelEvent.send(.fetchFailed)
            }
        }
    }
    
    private func checkIfHasLazySynopsis(from animes: [Jikan.AnimeDetails]) async throws -> [Jikan.AnimeDetails] {
        // MARK: Removed the async task group implementation
        // because Jikan API only accepts 3 API calls per second
        // I need to atleast wait 0.5 seconds to accomodate 3 API calls per second
        // to fill the lazy synopsis with the original synopsis
        // for better content display
        var updatedAnimes: [Jikan.AnimeDetails] = animes
        for anime in animes {
            let minimumCount = 164
            let synopsis = anime.synopsis ?? ""
            let isLazySynopsis = synopsis.count <= minimumCount
            if isLazySynopsis {
                let newSynopsis = await self.getOriginalSynopsis(from: synopsis)
                if let index = updatedAnimes.firstIndex(where: { AnimeDetails -> Bool in
                    AnimeDetails.id == anime.id
                }) {
                    updatedAnimes[index].synopsis = newSynopsis
                }
            }
        }
        return updatedAnimes
    }
    
    private func getOriginalSynopsis(from lazySynopsis: String) async -> String? {
        let matches = lazySynopsis.match(
            Jikan.Matcher.getTitleFromLazySynopsis.rawValue,
            options: [.caseInsensitive]
        )
        let flatten = Array(matches.joined())
        guard let lazySynopsisWithTitle = flatten.first else {
            return lazySynopsis
        }
        let originalAnimeTitle = String(
            lazySynopsisWithTitle
                .trimmingCharacters(in: .whitespacesAndNewlines)
        )
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
            let matchedAnime = try await self.jikan.searchAnimeByTitle(using: originalAnimeTitle)
            let originalSynopsis = Common.trimSynopsis(from: matchedAnime?.synopsis ?? lazySynopsis)
            return originalSynopsis
        } catch {
            return lazySynopsis
        }
    }
    
    private func getScheduleForToday() async throws -> [Jikan.AnimeDetails] {
        do {
            let date = Date()
            let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE"
                return formatter
            }()
            let dayOfTheWeek = dateFormatter.string(from: date).lowercased()
            let animes = try await jikan.getSchedule(filter: dayOfTheWeek, limit: 0)
            let scheduleForToday = animes?.sorted(by: {
                ($0.broadcast?.time ?? "") < ($1.broadcast?.time ?? "")
            }) ?? []
            return scheduleForToday
        } catch {
            throw error
        }
    }
}

enum DashboardEvents {
    enum UIEvent {
        case viewDidLoad
        case getAnimeDetails(index: Int)
        case changedCategory(_ category: Jikan.TopAnimeType)
    }
    
    enum ViewModelEvent {
        case fetchSuccess(_ topAnimes: [Jikan.AnimeDetails], _ scheduledAnimesForToday: [Jikan.AnimeDetails])
        case fetchFailed
        case showAnimeDetails(_ details: Anime)
        case showUpdatedTopAnimes(_ topAnimes: [Jikan.AnimeDetails])
    }
}
