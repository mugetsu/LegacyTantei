//
//  SearchViewModel.swift
//  Tantei-san
//
//  Created by Randell on 28/9/22.
//

import Foundation

final class SearchViewModel {
    weak var delegate: RequestDelegate?
    private var state: ViewState {
        didSet {
            self.delegate?.didUpdate(with: state)
        }
    }
    
    private var animes: [Trace.AnimeResult] = []
    
    init() {
        self.state = .idle
    }
}

// MARK: - DataSource
extension SearchViewModel {
    var numberOfItems: Int {
        animes.count
    }
    
    func getAnime(for indexPath: IndexPath) -> Trace.AnimeResult {
        animes[indexPath.row]
    }
}

// MARK: - Services
extension SearchViewModel {
    func searchByURL(url: String) {
        Task {
            self.state = .loading
            AnimeService.getAnimeByURL(url: url) { result in
                switch result {
                case let .success(animeResult):
                    self.animes = animeResult
                    self.state = .success
                case let .failure(error):
                    self.animes = []
                    self.state = .error(error)
                }
            }
        }
    }
}
