//
//  DetailViewModel.swift
//  Tantei
//
//  Created by Randell on 10/11/22.
//

import Combine
import Foundation

final class DetailViewModel {
    var anime: Anime
    
    init(anime: Anime) {
        self.anime = anime
    }
    
    private var viewModelEvent = PassthroughSubject<DetailEvents.ViewModelEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    func bind(_ uiEvents: AnyPublisher<DetailEvents.UIEvent, Never>) -> AnyPublisher<DetailEvents.ViewModelEvent, Never> {
        uiEvents.sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .viewDidLoad:
                self.viewModelEvent.send(.fetchData(anime: self.anime))
            }
        }.store(in: &cancellables)
        return viewModelEvent.eraseToAnyPublisher()
    }
}

enum DetailEvents {
    enum UIEvent {
        case viewDidLoad
    }
    
    enum ViewModelEvent {
        case fetchData(anime: Anime)
    }
}
