//
//  DetailViewModel.swift
//  Tantei-san
//
//  Created by Randell on 28/10/22.
//

import Foundation

final class DetailViewModel {
    weak var delegate: RequestDelegate?
    
    private var state: ViewState {
        didSet {
            self.delegate?.didUpdate(with: state)
        }
    }
    
    private let anime: Anime
    
    private var properSynopsis: String
    
    init(anime: Anime) {
        self.anime = anime
        self.properSynopsis = anime.synopsis
        self.state = .idle
    }
}

// MARK: DataSource
extension DetailViewModel {
    func getAnime() -> Anime {
        return anime
    }
    
    func getProperSynopsis() -> String {
        return properSynopsis
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
    
    func checkAnimeHasLazySynopsis() {
        Task {
            let synopsis = properSynopsis
            let minimumCount = 164
            var genesisTitle: String = ""
            guard synopsis.count <= minimumCount else {
                return
            }
            let matches = synopsis.match("(?<=season of|part of).*$")
            let flatten = Array(matches.joined())
            guard let dirtyTitle = flatten.first else {
                return
            }
            genesisTitle = String(
                dirtyTitle
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .dropLast()
            )
            getAnimeByTitle(title: genesisTitle)
        }
    }
}

// MARK: Services
extension DetailViewModel {
    func getAnimeByTitle(title: String) {
        Task {
            AnimeService.searchAnimeByTitle(using: title) { result in
                switch result {
                case .success(let matchedAnime):
                    guard let synopsis = matchedAnime.synopsis else { return }
                    self.properSynopsis = self.trimSynopsis(from: synopsis)
                    self.state = .success
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
