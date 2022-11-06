//
//  SearchViewModel.swift
//  Tantei
//
//  Created by Randell on 28/9/22.
//

import Foundation

final class SearchViewModel {
    private var state: ViewState {
        didSet {
            self.delegate?.didUpdate(with: state)
        }
    }
    
    private var trace: TraceAPI = TraceAPI()
    
    private var result: [Trace.AnimeDetails] = []
    
    weak var delegate: RequestDelegate?
    
    init() {
        self.state = .idle
    }
}

// MARK: DataSource
extension SearchViewModel {
    var numberOfItems: Int {
        return result.count
    }
    
    func getAnime(with index: Int) -> Trace.AnimeDetails {
        return result[index]
    }
    
    func clearResult() {
        result = []
        state = .idle
    }
    
    func createSearchResultModel(with anime: Trace.AnimeDetails) -> SearchResult {
        var title: String = ""
        var model: SearchResult = SearchResult(
            title: title,
            matchPercent: "",
            episode: "",
            timestamp: ""
        )
        guard let titles = anime.anilist?.title else {
            return model
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
        model = SearchResult(
            title: title,
            matchPercent: matchPercent,
            episode: episode,
            timestamp: timestamp
        )
        return model
    }
}

// MARK: Services
extension SearchViewModel {
    func searchByImageURL(url: String) {
        Task {
            do {
                state = .loading
                result = try await trace.searchAnimeByURL(url: url)
                state = .success
            } catch {
                state = .error(error)
            }
        }
    }
}
