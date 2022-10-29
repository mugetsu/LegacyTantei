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
}

// MARK: Services
extension DashboardViewModel {
    func getTopAnimes(type: AnimeService.SearchQueryType, filter: AnimeService.SearchFilterType) {
        Task {
            try await Task.sleep(nanoseconds: 1_500_000_000)
            AnimeService.getTopAnimes(type: type, filter: filter, limit: maximumTopAnimesForDisplay) { result in
                switch result {
                case .success(let animeResult):
                    self.topAnimes = animeResult
                    self.state = .success
                case .failure(let error):
                    self.topAnimes = []
                    self.state = .error(error)
                }
            }
        }
    }
}
