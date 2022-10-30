//
//  SwipeableCardsViewDataSource.swift
//  Tantei
//
//  Created by Randell on 9/10/22.
//

import Foundation

protocol SwipeableCardsViewDataSource {
    func swipeableCardsNumberOfItems(_ : SwipeableCardsView) -> Int
    func swipeableCardsView(_ : SwipeableCardsView, viewForIndex index: Int) -> SwipeableCard
}
