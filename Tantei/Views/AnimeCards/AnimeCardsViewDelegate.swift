//
//  AnimeCardsViewDelegate.swift
//  Tantei
//
//  Created by Randell on 1/11/22.
//

import Foundation

protocol AnimeCardsViewDelegate {
    func didSelectItem(at index: Int, from type: Jikan.TopAnimeType)
}
