//
//  AnimeDelegate.swift
//  Tantei
//
//  Created by Randell on 31/10/22.
//

import Foundation

protocol AnimeDelegate {
    func didSelectItem(at index: Int, from type: AnimeCardType)
}
