//
//  DashboardViewModel.swift
//  Tantei
//
//  Created by Randell on 1/10/22.
//

import Foundation

final class DashboardViewModel {
    weak var delegate: RequestDelegate?
    
    private var state: ViewState {
        didSet {
            self.delegate?.didUpdate(with: state)
        }
    }
    
    private var topAnimes: [Jikan.AnimeDetails] = []
    
    init() {
        self.state = .idle
    }
}

// MARK: DataSource
extension DashboardViewModel {
    var isSuccess: Bool {
        return state == .success
    }
    
    var maximumTopAnimesForDisplay: Int {
        return 10
    }
    
    func getAnimeFromTopAnimes(with index: Int) -> Jikan.AnimeDetails {
        return topAnimes[index]
    }
    
    func trimSynopsis(from synopsis: String) -> String {
        let cleanSynopsis = synopsis
            .replacingOccurrences(
                of: "\\(Source:.*\\)|\\[Written.*\\]",
                with: "",
                options: .regularExpression,
                range: nil
            )
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        return cleanSynopsis
    }
    
    func createTopAnimeModel(with anime: Jikan.AnimeDetails) -> Anime {
        var model: Anime = .init(
            malId: 0,
            imageURL: "",
            title: "",
            rating: .g,
            genres: [],
            synopsis: ""
        )
        guard let malId = anime.malId,
              let imageURL = anime.images?.webp?.large,
              let titles = anime.titles?.last(where: { $0.type == "Default" || $0.type == "English" }),
              let title = titles.title,
              let rating = Anime.Rating(rawValue: anime.rating ?? ""),
              let relativeGenre = anime.genres
        else {
            return model
        }
        let genres = relativeGenre.map { genre -> Anime.Genre in
            guard let name = Anime.Genre(rawValue: genre.name ?? "") else {
                return .others
            }
            return name
        }
        let synopsis = trimSynopsis(from: anime.synopsis ?? "")
        model = Anime(
            malId: malId,
            imageURL: imageURL,
            title: title,
            rating: rating,
            genres: genres,
            synopsis: synopsis
        )
        return model
    }
    
    func checkIfHasLazySynopsis() {
        Task {
            topAnimes.map { anime in
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
            topAnimes = topAnimes.map { anime in
                var updatedSynopsisAnime = anime
                guard updatedSynopsisAnime.malId == id else {
                    return anime
                }
                updatedSynopsisAnime.synopsis = trimSynopsis(from: synopsis)
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
            greetingText = "Good\nMorning \u{1F324}"
        case noon..<sunset:
            greetingText = "Good\nAfternoon \u{26C5}"
        case sunset..<midnight:
            greetingText = "Good\nEvening \u{1F319}"
        default:
            break
        }
        return greetingText
    }
}

// MARK: Services
extension DashboardViewModel {
    func getTopAnimes(type: AnimeService.SearchQueryType, filter: AnimeService.SearchFilterType) {
        Task {
            AnimeService.getTopAnimes(type: type, filter: filter, limit: maximumTopAnimesForDisplay) { result in
                switch result {
                case .success(let animeResult):
                    self.topAnimes = animeResult
                    self.checkIfHasLazySynopsis()
                    self.state = .success
                case .failure(let error):
                    self.topAnimes = []
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
