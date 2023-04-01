//
//  MyAnimeListAPIProtocol.swift
//  Tantei
//
//  Created by Randell Quitain on 1/4/23.
//

import Foundation

protocol MyAnimeListAPIProtocol {
    func getTopAnimes(filter: MyAnimeList.TopAnimeType, limit: Int) async throws -> [MyAnimeList.AnimeNode]?
}
