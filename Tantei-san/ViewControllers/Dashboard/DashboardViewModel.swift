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
    
    private var animes: [Jikan.AnimeDetails] = []
    
    init() {
        self.state = .idle
    }
}

// MARK: DataSource
extension DashboardViewModel {
    var numberOfItems: Int {
        return animes.count
    }
    
    func getAnimes() -> [Jikan.AnimeDetails] {
        return animes
    }
    
    func getAnime(for index: Int) -> Jikan.AnimeDetails {
        return animes[index]
    }
    
    func createTopAnimeModel(with anime: Jikan.AnimeDetails) -> TopAnime {
        var model: TopAnime = TopAnime(
            title: "",
            imageURL: ""
        )
        guard let titles = anime.titles?.first(where: { $0.type == "English" || $0.type == "Default" }),
              let title = titles.title,
              let imageURL = anime.images?.webp?.regular
        else {
            return model
        }
        model = TopAnime(
            title: title,
            imageURL: imageURL
        )
        return model
    }
}

// MARK: Services
extension DashboardViewModel {
    func getTopAnimes(type: AnimeService.SearchQueryType, filter: AnimeService.SearchFilterType) {
        Task {
            self.state = .loading
            AnimeService.getTopAnime(type: type, filter: filter) { result in
                switch result {
                case .success(let animeResult):
                    self.animes = animeResult
                    self.state = .success
                case .failure(let error):
                    self.animes = []
                    self.state = .error(error)
                }
            }
        }
    }
}
