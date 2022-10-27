//
//  DashboardViewModel.swift
//  Tantei-san
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
    var maximumTopAnimesForDisplay: Int {
        return 10
    }
    
    func getAnimeFromTopAnimes(with index: Int) -> Jikan.AnimeDetails {
        return topAnimes[index]
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
        let synopsis = (anime.synopsis ?? "")
            .replacingOccurrences(
                of: "\\(Source:.*\\)|\\[Written.*\\]",
                with: "",
                options: .regularExpression,
                range: nil
            )
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
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
    
    func checkLazySynopsis() {
        Task {
            topAnimes.forEach { anime in
                guard let malId = anime.malId,
                      let synopsis = anime.synopsis else {
                    return
                }
                let minimumCount = 164
                var genesisTitle: String = ""
                guard synopsis.count <= minimumCount else { return }
                let matches = synopsis.match("(?<=season of|part of).*$")
                let flatten = Array(matches.joined())
                guard let dirtyTitle = flatten.first else { return }
                genesisTitle = String(
                    dirtyTitle
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .dropLast()
                )
                getAnimeByTitle(id: malId, title: genesisTitle)
            }
        }
    }
    
    func updateLazySynopsis(using synopsis: String, from id: Int) {
        Task {
            topAnimes = topAnimes.map { topAnime -> Jikan.AnimeDetails in
                var updatedTopAnime = topAnime
                if updatedTopAnime.malId == id {
                    updatedTopAnime.synopsis = synopsis
                    return updatedTopAnime
                } else {
                    return updatedTopAnime
                }
            }
        }
    }
}

// MARK: Services
extension DashboardViewModel {
    func getTopAnimes(type: AnimeService.SearchQueryType, filter: AnimeService.SearchFilterType) {
        Task {
            self.state = .loading
            AnimeService.getTopAnimes(type: type, filter: filter, limit: maximumTopAnimesForDisplay) { result in
                switch result {
                case .success(let animeResult):
                    self.topAnimes = animeResult
                    self.checkLazySynopsis()
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
            try await Task.sleep(nanoseconds: 1_000_000_000)
            AnimeService.searchAnimeByTitle(using: title) { result in
                switch result {
                case .success(let anime):
                    guard let synopsis = anime.synopsis else { return }
                    self.updateLazySynopsis(using: synopsis, from: id)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
