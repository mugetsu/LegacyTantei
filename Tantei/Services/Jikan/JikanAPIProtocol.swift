//
//  JikanAPIProtocol.swift
//  Tantei
//
//  Created by Randell on 5/11/22.
//

import Foundation

protocol JikanAPIProtocol {
    func getScheduleToday(filter: String, limit: Int) async throws -> [Jikan.AnimeDetails]?
    func getTopAnimes(type: Jikan.AnimeType, filter: Jikan.TopAnimeType, limit: Int) async throws -> [Jikan.AnimeDetails]?
    func searchAnimeByTitle(using keyword: String) async throws -> Jikan.AnimeDetails?
}
