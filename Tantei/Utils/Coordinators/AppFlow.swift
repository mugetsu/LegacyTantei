//
//  AppFlow.swift
//  Tantei
//
//  Created by Randell on 8/10/22.
//

enum AppFlow {
    case authentication(AuthenticationScreen)
    case dashboard(DashboardScreen)
    case search(SearchScreen)
}

enum AuthenticationScreen {
    case initial
}

enum DashboardScreen {
    case initial
}

enum SearchScreen {
    case initial
}
