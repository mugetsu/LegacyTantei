//
//  AuthenticationViewModel.swift
//  Tantei-san
//
//  Created by Randell on 8/10/22.
//

import Foundation

final class AuthenticationViewModel {
    weak var delegate: RequestDelegate?
    private var state: ViewState {
        didSet {
            self.delegate?.didUpdate(with: state)
        }
    }
    
    init() {
        self.state = .idle
    }
}

// MARK: Services
extension AuthenticationViewModel {}
