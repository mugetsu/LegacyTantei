//
//  DashboardViewModel.swift
//  Tantei
//
//  Created by Randell on 1/10/22.
//

import Foundation

final class DashboardViewModel {
    private var state: ViewState {
        didSet {
            self.delegate?.didUpdate(with: state)
        }
    }
    
    private let jikan: JikanAPI = JikanAPI()
    
    private var scheduledForToday: [Jikan.AnimeDetails] = []
    
    private var topAnime: [Jikan.AnimeDetails] = []
    
    weak var delegate: RequestDelegate?
    
    init() {
        self.state = .idle
    }
}

// MARK: DataSource
extension DashboardViewModel {
    var maximumTopAnimesForDisplay: Int {
        return 10
    }
    
    var categoryTitles: [String] {
        var titles: [String] = []
        Jikan.TopAnimeType.allCases.forEach { type in
            titles.append(type.description)
        }
        return titles
    }
    
    func fetchData() {
        Task {
            do {
                state = .loading
                async let scheduledForTodayAnimes = getAnimesScheduledForToday()
                scheduledForToday = try await scheduledForTodayAnimes
                async let defaultTopAnime = getTopAnimeForDisplay(
                    type: .tv,
                    filter: .airing
                )
                topAnime = try await defaultTopAnime
                state = .success
            } catch {
                state = .error(error)
            }
        }
    }
    
    func checkIfHasLazySynopsis(from animes: [Jikan.AnimeDetails]) async throws -> [Jikan.AnimeDetails] {
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
    
    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let newDay = 0
        let noon = 12
        let sunset = 18
        let midnight = 24
        var greetingText = "Hello"
        switch hour {
        case newDay..<noon:
            greetingText = "Good\nMorning"
        case noon..<sunset:
            greetingText = "Good\nAfternoon"
        case sunset..<midnight:
            greetingText = "Good\nEvening"
        default:
            break
        }
        return greetingText
    }
    
    func getScheduledForToday() -> [Jikan.AnimeDetails] {
        return scheduledForToday.sorted(by: {
            ($0.broadcast?.time ?? "") < ($1.broadcast?.time ?? "")
        })
    }
    
    func getTopAnime() -> [Jikan.AnimeDetails] {
        return topAnime
    }
    
    func setTopAnime(with animes: [Jikan.AnimeDetails]) {
        topAnime = animes
    }
}

// MARK: Services
extension DashboardViewModel {
    func getAnimesScheduledForToday() async throws -> [Jikan.AnimeDetails] {
        do {
            let date = Date()
            let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE"
                return formatter
            }()
            let dayOfTheWeek = dateFormatter.string(from: date).lowercased()
            let animesScheduledForToday = try await jikan.getScheduleToday(filter: dayOfTheWeek, limit: 0)
            return animesScheduledForToday ?? []
        } catch {
            throw error
        }
    }
    
    func getOriginalSynopsis(from lazySynopsis: String) async -> String? {
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
    
    func getTopAnimeForDisplay(type: Jikan.AnimeType, filter: Jikan.TopAnimeType) async throws -> [Jikan.AnimeDetails] {
        do {
            let topAnimes = try await jikan.getTopAnimes(
                type: type,
                filter: filter,
                limit: maximumTopAnimesForDisplay
            )
            let updatedTopAnimes = try await checkIfHasLazySynopsis(from: topAnimes ?? [])
            return updatedTopAnimes
        } catch {
            throw error
        }
    }
    
    func updateTopAnimeForDisplay(type: Jikan.AnimeType, filter: Jikan.TopAnimeType) async {
        Task {
            do {
                state = .loading
                let updatedTopAnime = try await getTopAnimeForDisplay(
                    type: type,
                    filter: filter
                )
                setTopAnime(with: updatedTopAnime)
                state = .success
            } catch {
                state = .error(error)
            }
        }
    }
}
