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
            $0.height.equalTo(300)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalTo(view.safeAreaLayoutGuide)
            $0.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: SwipeableCardsViewDataSource
extension DashboardView: SwipeableCardsViewDataSource {
    func swipeableCardsNumberOfItems(_ collectionView: SwipeableCardsView) -> Int {
        return viewModel.numberOfItems
    }

    func swipeableCardsView(_: SwipeableCardsView, viewForIndex index: Int) -> SwipeableCard {
        let anime = viewModel.getAnime(for: index)
        let topAnime = viewModel.createTopAnimeModel(with: anime)
        let swipeableCard: SwipeableCard = {
            let swipeableCard = SwipeableCard()
            swipeableCard.backgroundColor = UIColor.Elements.backgroundDark
            return swipeableCard
        }()
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = topAnime.title
            label.font = UIFont.Custom.medium?.withSize(21)
            label.textColor = UIColor.Elements.cardHeading
            label.numberOfLines = 0
            label.setContentHuggingPriority(.defaultLow, for: .horizontal)
            label.setContentCompressionResistancePriority(.required, for: .horizontal)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        let backgroundImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.kf.setImage(
                with: URL(string: topAnime.imageURL),
                placeholder: #imageLiteral(resourceName: "no-image")
            )
            return imageView
        }()
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.alignment = .leading
            return stackView
        }()
        stackView.addArrangedSubview(backgroundImageView)
        stackView.sendSubviewToBack(backgroundImageView)
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalTo(stackView)
        }
        swipeableCard.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return swipeableCard
    }
}

// MARK: SwipeableCardsViewDelegate
extension DashboardView: SwipeableCardsViewDelegate {
    func swipeableCardsView(_: SwipeableCardsView, didSelectItemAtIndex index: Int) {
        print("Tapped \(index)!")
    }
}
