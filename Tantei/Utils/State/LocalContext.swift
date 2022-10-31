//
//  LocalContext.swift
//  Tantei
//
//  Created by Randell on 31/10/22.
//

import Foundation

class LocalContext {
    static var shared = LocalContext()
    
    var topAiringAnimes: [Jikan.AnimeDetails] = []
}
