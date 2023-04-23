//
//  HeaderViewModel.swift
//  Tantei
//
//  Created by Randell Quitain on 23/4/23.
//

import Combine
import Foundation

final class HeaderViewModel {
    private var viewModelEvent = PassthroughSubject<HeaderEvents.ViewModelEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    func bind(_ uiEvents: AnyPublisher<HeaderEvents.UIEvent, Never>) -> AnyPublisher<HeaderEvents.ViewModelEvent, Never> {
        uiEvents.sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .initialized:
                let message = self.getGreeting()
                self.viewModelEvent.send(.showGreeting(message))
            case .menuTapped:
                self.viewModelEvent.send(.showMenu([]))
            }
        }.store(in: &cancellables)
        return viewModelEvent.eraseToAnyPublisher()
    }
    
    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let newDay = 0
        let noon = 12
        let sunset = 18
        let midnight = 24
        var greetingText = "Hello"
        switch hour {
        case newDay..<noon:
            greetingText = "Good\nMorning"
        case noon..<sunset:
            greetingText = "Good\nAfternoon"
        case sunset..<midnight:
            greetingText = "Good\nEvening"
        default:
            break
        }
        return greetingText
    }
}

enum HeaderEvents {
    enum UIEvent {
        case initialized
        case menuTapped
    }
    
    enum ViewModelEvent {
        case showGreeting(_ message: String)
        case showMenu(_ menuItems: [String])
    }
}

