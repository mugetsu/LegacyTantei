//
//  DashboardView+TopAnime.swift
//  Tantei-san
//
//  Created by Randell on 10/10/22.
//

import Foundation
import Kingfisher
import KingfisherWebP
import UIKit

// MARK: UI Setup
extension DashboardView {
    func updateTopAnimeView() {
        topAnimeView.dataSource = self
        topAnimeView.delegate = self
        view.addSubview(topAnimeView)
        topAnimeView.snp.makeConstraints {
            $0.height.equalTo(503)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalTo(view.safeAreaLayoutGuide)
            $0.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: SwipeableCardsViewDataSource
extension DashboardView: SwipeableCardsViewDataSource {
    func swipeableCardsNumberOfItems(_ collectionView: SwipeableCardsView) -> Int {
        return viewModel.maximumTopAnimesForDisplay
    }

    func swipeableCardsView(_ : SwipeableCardsView, viewForIndex index: Int) -> SwipeableCard {
        let anime = viewModel.getAnimeFromTopAnimes(with: index)
        let topAnime = viewModel.createTopAnimeModel(with: anime)
        let swipeableCard = buildSwipeableCard(using: topAnime)
        return swipeableCard
    }
}

// MARK: SwipeableCardsViewDelegate
extension DashboardView: SwipeableCardsViewDelegate {
    func swipeableCardsView(_ : SwipeableCardsView, didSelectItemAtIndex index: Int) {
        let anime = viewModel.getAnimeFromTopAnimes(with: index)
        let topAnime = viewModel.createTopAnimeModel(with: anime)
        presentModal(with: topAnime)
    }
}

// MARK: UI Setup
extension DashboardView {
    func buildSwipeableCard(using model: Anime) -> SwipeableCard {
        let swipeableCard: SwipeableCard = {
            let swipeableCard = SwipeableCard()
            swipeableCard.backgroundColor = UIColor.Elements.backgroundDark
            swipeableCard.layer.cornerRadius = 8
            swipeableCard.clipsToBounds = true
            return swipeableCard
        }()
        
        let backgroundImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.kf.setImage(
                with: URL(string: model.imageURL),
                placeholder: #imageLiteral(resourceName: "no-image")
            )
            return imageView
        }()
        
        swipeableCard.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        return swipeableCard
    }
    
    private func presentModal(with anime: Anime) {
        let detailView = DetailView(anime: anime)
        let navigationController = UINavigationController(rootViewController: detailView)
        navigationController.modalPresentationStyle = .pageSheet
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        present(navigationController, animated: true, completion: nil)
    }
}
