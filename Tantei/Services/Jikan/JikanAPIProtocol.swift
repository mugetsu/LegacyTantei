//
//  JikanAPIProtocol.swift
//  Tantei
//
//  Created by Randell on 5/11/22.
//

import Foundation

protocol JikanAPIProtocol {
    func getTopAnimes(type: AnimeType, filter: TopAnimeType, limit: Int) async throws -> [Jikan.AnimeDetails]?
    func searchAnimeByTitle(using keyword: String) async throws -> Jikan.AnimeDetails?
}
