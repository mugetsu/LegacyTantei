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
    private var result: [Trace.AnimeDetails] = []
    
    init() {
        self.state = .idle
    }
}

// MARK: DataSource
extension SearchViewModel {
    var numberOfItems: Int {
        result.count
    }
    
    func getAnime(for indexPath: IndexPath) -> Trace.AnimeDetails {
        result[indexPath.row]
    }
    
    func getResultTitle() -> String {
        return resultTitle
    }
    
    func clearResult() {
        resultTitle = ""
        result = []
        state = .idle
    }
}

// MARK: Actions
extension SearchViewModel {
    func createCellViewModel(with anime: Trace.AnimeDetails) -> SearchCellViewModel {
        var title: String = ""
        var viewModel: SearchCellViewModel = SearchCellViewModel(
            title: title,
            matchPercent: "",
            episode: "",
            timestamp: ""
        )
        guard let titles = anime.anilist?.title else {
            return viewModel
        }
        let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.generatesDecimalNumbers = true
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
            return formatter
        }()
        if let titleEnglish = titles.english {
            title = titleEnglish
        } else if let titleRomaji = titles.romaji {
            title = titleRomaji
        } else if let titleNative = titles.native {
            title = titleNative
        }
        let similarity = (anime.similarity ?? 0) * 100
        let from = (anime.from ?? 0).getMinutes()
        let to = (anime.to ?? 0).getMinutes()
        let matchPercent = "\(formatter.string(from: similarity as NSNumber) ?? "0")%"
        let episode = "Episode \(anime.episode ?? 1)"
        let timestamp = "\(from) - \(to)"
        viewModel = SearchCellViewModel(
            title: title,
            matchPercent: matchPercent,
            episode: episode,
            timestamp: timestamp
        )
        return viewModel
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
                    self.result = animeResult
                    self.state = .success
                case .failure(let error):
                    self.result = []
                    self.state = .error(error)
                }
            }
        }
    }
}
