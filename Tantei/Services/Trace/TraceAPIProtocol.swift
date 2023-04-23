//
//  TraceAPIProtocol.swift
//  Tantei
//
//  Created by Randell on 6/11/22.
//

import Foundation

protocol TraceAPIProtocol {
    func searchAnimeByURL(url: String) async throws -> [Trace.AnimeDetails]
}
