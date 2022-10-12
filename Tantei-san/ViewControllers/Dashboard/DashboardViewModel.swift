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
        let maxCount = Double(topAnimes.count / 2)
        return Int(floor(maxCount))
    }
    
    func getAnimeFromTopAnimes(with index: Int) -> Jikan.AnimeDetails {
        return topAnimes[index]
    }
    
    func createTopAnimeModel(with anime: Jikan.AnimeDetails) -> TopAnime {
        var model: TopAnime = TopAnime(
            title: "",
            imageURL: ""
        )
        guard let titles = anime.titles?.last(where: { $0.type == "Default" || $0.type == "English" }),
              let title = titles.title,
              let imageURL = anime.images?.webp?.large
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
