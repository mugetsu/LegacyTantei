//
//  ViewState.swift
//  Tantei
//
//  Created by Randell on 28/9/22.
//

import Foundation

enum ViewState: Equatable {
    case idle
    case loading
    case success
    case error(Error)
}

extension ViewState {
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.success, .success):
            return true
        case (.error(_), .error(_)):
            return true
        default:
            return false
        }
    }
}
