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
        animes.count
    }
    
    func getAnimes() -> [Jikan.AnimeDetails] {
        animes
    }
    
    func getAnime(for index: Int) -> Jikan.AnimeDetails {
        animes[index]
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
