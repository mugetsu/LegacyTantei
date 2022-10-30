//
//  DashboardView+TopAnime.swift
//  Tantei
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
        view.addSubview(topAnimeView)
        topAnimeView.dataSource = self
        topAnimeView.delegate = self
        topAnimeView.snp.makeConstraints {
            $0.height.equalTo(503)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        UIView.animate(
            withDuration: 1.0,
            animations: {
                self.skeletonView.alpha = 0.0
                self.topAnimeView.alpha = 1.0
            },
            completion: { _ in
                self.skeletonView.removeFromSuperview()
            }
        )
    }
}

// MARK: SwipeableCardsViewDataSource
extension DashboardView: SwipeableCardsViewDataSource {
    func swipeableCardsNumberOfItems(_ collectionView: SwipeableCardsView) -> Int {
        return viewModel.isSuccess ? viewModel.maximumTopAnimesForDisplay : 2
    }

    func swipeableCardsView(_ : SwipeableCardsView, viewForIndex index: Int) -> SwipeableCard {
        if viewModel.isSuccess {
            let anime = viewModel.getAnimeFromTopAnimes(with: index)
            let topAnime = viewModel.createTopAnimeModel(with: anime)
            let swipeableCard = buildSwipeableCard(using: topAnime)
            return swipeableCard
        } else {
            let skeletonCard: SwipeableCard = {
                let swipeableCard = SwipeableCard()
                swipeableCard.backgroundColor = UIColor.Elements.backgroundLight
                swipeableCard.layer.cornerRadius = 8
                swipeableCard.clipsToBounds = true
                return swipeableCard
            }()
            return skeletonCard
        }
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
            let processor = WebPProcessor.default
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.kf.setImage(
                with: URL(string: model.imageURL),
                placeholder: UIImage(named: "no-image"),
                options: [
                    .processor(processor),
                    .cacheSerializer(WebPSerializer.default),
                    .loadDiskFileSynchronously,
                    .cacheOriginalImage,
                    .transition(.fade(0.25))
                ]
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
