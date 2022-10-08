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
    
    private var resultTitle: String = ""
    private var animes: [Trace.AnimeDetails] = []
    
    init() {
        self.state = .idle
    }
}

// MARK: DataSource
extension SearchViewModel {
    var numberOfItems: Int {
        animes.count
    }
    
    func getAnime(for indexPath: IndexPath) -> Trace.AnimeDetails {
        animes[indexPath.row]
    }
}

// MARK: Actions
extension SearchViewModel {
    func getResultTitle() -> String {
        return resultTitle
    }
    
    func clearResult() {
        resultTitle = ""
        animes = []
        state = .idle
    }
}

// MARK: Services
extension SearchViewModel {
    func searchByURL(url: String) {
        Task {
            self.state = .loading
            AnimeService.getAnimeByURL(url: url) { result in
                switch result {
                case .success(let animeResult):
                    self.resultTitle = "Check out these!"
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
