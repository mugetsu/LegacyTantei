//
//  DashboardViewModel.swift
//  Tantei
//
//  Created by Randell on 1/10/22.
//

import Foundation

final class DashboardViewModel {
    private(set) var currentContext = LocalContext.shared
    
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
        let titles = ["Airing", "Upcoming", "Popular", "Favorite"]
        return titles + titles
    }
    
    func checkIfHasLazySynopsis() {
        Task {
            currentContext.topAiringAnimes.map { anime in
                let minimumCount = 164
                var originalAnimeTitle: String = ""
                guard let id = anime.malId,
                      let synopsis = anime.synopsis,
                      synopsis.count <= minimumCount else {
                    return
                }
                let matches = synopsis.match("(?<=season of|part of).*$")
                let flatten = Array(matches.joined())
                guard let dirtyTitle = flatten.first else {
                    return
                }
                originalAnimeTitle = String(
                    dirtyTitle
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .dropLast()
                )
                getAnimeByTitle(id: id, title: originalAnimeTitle)
            }
        }
    }
    
    func processAnimeSynopsis(with synopsis: String, id: Int) {
        Task {
            currentContext.topAiringAnimes = currentContext.topAiringAnimes.map { anime in
                var updatedSynopsisAnime = anime
                guard updatedSynopsisAnime.malId == id else {
                    return anime
                }
                updatedSynopsisAnime.synopsis = Common.trimSynopsis(from: synopsis)
                return updatedSynopsisAnime
            }
        }
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
    
    func getTopAiringAnimes() -> [Jikan.AnimeDetails] {
        return currentContext.topAiringAnimes
    }
}

// MARK: Services
extension DashboardViewModel {
    func getTopAnimes(type: AnimeService.SearchQueryType, filter: AnimeService.SearchFilterType) {
        Task {
            AnimeService.getTopAnimes(type: type, filter: filter, limit: maximumTopAnimesForDisplay) { result in
                switch result {
                case .success(let animeResult):
                    self.currentContext.topAiringAnimes = animeResult
                    self.checkIfHasLazySynopsis()
                    self.state = .success
                case .failure(let error):
                    self.state = .error(error)
                }
            }
        }
    }
    
    func getAnimeByTitle(id: Int, title: String) {
        Task {
            try await Task.sleep(nanoseconds: 500_000_000)
            AnimeService.searchAnimeByTitle(using: title) { result in
                switch result {
                case .success(let matchedAnime):
                    guard let synopsis = matchedAnime.synopsis else { return }
                    self.processAnimeSynopsis(with: synopsis, id: id)
                    self.state = .success
                case .failure(let error):
                    self.state = .error(error)
                }
            }
        }
    }
}
