//
//  SplashViewModel.swift
//  Tantei
//
//  Created by Randell Quitain on 23/4/23.
//

import Combine
import Foundation

final class SplashViewModel {
    private var viewModelEvent = PassthroughSubject<SplashEvents.ViewModelEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var currentContext = LocalContext.shared
    private let jikan = JikanAPI()
    
    func bind(_ uiEvents: AnyPublisher<SplashEvents.UIEvent, Never>) -> AnyPublisher<SplashEvents.ViewModelEvent, Never> {
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
                async let defaultTopAnimes = try await jikan.getTopAnimes(
                    type: .tv,
                    filter: .airing,
                    limit: 10
                )
                let updatedTopAnimes = try await checkIfHasLazySynopsis(
                    from: defaultTopAnimes ?? []
                )
                async let scheduleForToday = try await getScheduleForToday()
                currentContext.topAnimes = updatedTopAnimes
                currentContext.scheduledAnimesForToday = try await scheduleForToday
                viewModelEvent.send(.fetchSuccess)
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

enum SplashEvents {
    enum UIEvent {
        case viewDidLoad
    }
    
    enum ViewModelEvent {
        case fetchSuccess
        case fetchFailed
    }
}

