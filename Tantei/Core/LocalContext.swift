//
//  LocalContext.swift
//  Tantei
//
//  Created by Randell Quitain on 23/4/23.
//

import Foundation

class LocalContext {
    static let shared = LocalContext()
    var isAuthenticated: Bool = false
    var menuItems: [String] = []
    var topAnimes: [Jikan.AnimeDetails] = []
    var scheduledAnimesForToday: [Jikan.AnimeDetails] = []
}
