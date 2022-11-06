//
//  DashboardViewModel.swift
//  Tantei
//
//  Created by Randell on 1/10/22.
//

import Foundation

final class DashboardViewModel {
    private(set) var currentContext = LocalContext.shared
    
    private var jikan: JikanAPI = JikanAPI()
    
    weak var delegate: RequestDelegate?
    
    private var state: ViewState {
        didSet {
            self.delegate?.didUpdate(with: state)
        }
    }
    
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
                // MARK: Schedule
                async let scheduledForTodayAnimes = getAnimesScheduledForToday()
                currentContext.scheduledForToday = await scheduledForTodayAnimes
                
                // MARK: Top Anime
                let topAiringAnimes = try await jikan.getTopAnimes(type: .tv, filter: .airing, limit: maximumTopAnimesForDisplay)
                async let updatedTopAiringAnimes = try await checkIfHasLazySynopsis(from: topAiringAnimes ?? [])
                currentContext.topAiring = try await updatedTopAiringAnimes
                
                state = .success
            } catch {
                state = .error(error)
            }
        }
    }
    
    func checkIfHasLazySynopsis(from animes: [Jikan.AnimeDetails]) async throws -> [Jikan.AnimeDetails] {
        var updatedAnimes: [Jikan.AnimeDetails] = animes
        let animeWithOriginalSynopsis = await withTaskGroup(of: (Jikan.AnimeDetails.ID, String?).self) { group in
            for anime in animes {
                let minimumCount = 164
                let synopsis = anime.synopsis ?? ""
                let isLazySynopsis = synopsis.count <= minimumCount
                if isLazySynopsis {
                    group.addTask {
                        await (anime.id, self.getOriginalSynopsis(from: synopsis))
                    }
                }
            }
            return await group.reduce(into: [Jikan.AnimeDetails.ID: String]()) { (dictionary, result) in
                if let synopsis = result.1 {
                    dictionary[result.0] = synopsis
                }
            }
        }
        animeWithOriginalSynopsis.forEach { item in
            if let index = updatedAnimes.firstIndex(where: { AnimeDetails -> Bool in
                AnimeDetails.id == item.key
            }) {
                updatedAnimes[index].synopsis = item.value
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
        return currentContext.scheduledForToday
    }
    
    func getTopAiring() -> [Jikan.AnimeDetails] {
        return currentContext.topAiring
    }
}

// MARK: Services
extension DashboardViewModel {
    func getOriginalSynopsis(from lazySynopsis: String) async -> String? {
        let matches = lazySynopsis.match("(?<=season of|part of).*$")
        let flatten = Array(matches.joined())
        guard let lazySynopsisWithTitle = flatten.first else {
            return lazySynopsis
        }
        let originalAnimeTitle = String(
            lazySynopsisWithTitle
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .dropLast()
        )
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
            let matchedAnime = try await jikan.searchAnimeByTitle(using: originalAnimeTitle)
            let originalSynopsis = Common.trimSynopsis(from: matchedAnime?.synopsis ?? lazySynopsis)
            return originalSynopsis
        } catch {
            return lazySynopsis
        }
    }
    
    func getAnimesScheduledForToday() async -> [Jikan.AnimeDetails] {
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
            return []
        }
    }
}
