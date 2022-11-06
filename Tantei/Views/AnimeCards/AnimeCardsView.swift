//
//  AnimeCardsView.swift
//  Tantei
//
//  Created by Randell on 31/10/22.
//

import Kingfisher
import KingfisherWebP
import SnapKit
import UIKit

final class AnimeCardsView: UIView {
    private lazy var cardsView: SwipeableCardsView = {
        let swipeableCardsView = SwipeableCardsView()
        let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        swipeableCardsView.cardSpacing = 16
        swipeableCardsView.insets = insets
        swipeableCardsView.cardWidthFactor = 0.5
        return swipeableCardsView
    }()
    
    var animes: [Jikan.AnimeDetails] = []
    
    var delegate: AnimeCardsViewDelegate?
    
    required init(animes: [Jikan.AnimeDetails]) {
        self.animes = animes
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI Setup
private extension AnimeCardsView {
    func configureView() {
        cardsView.dataSource = self
        addSubview(cardsView)
        cardsView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func buildSwipeableCard(using model: Anime) -> SwipeableCard {
        let swipeableCard: SwipeableCard = {
            let swipeableCard = SwipeableCard()
            swipeableCard.backgroundColor = UIColor.Illustration.highlight
            swipeableCard.layer.cornerRadius = 8
            swipeableCard.clipsToBounds = true
            return swipeableCard
        }()
        let backgroundImageView: UIImageView = {
            let imageView = UIImageView()
            let processor = WebPProcessor.default
            imageView.tintColor = UIColor.Illustration.highlight
            imageView.contentMode = .scaleAspectFill
            imageView.kf.setImage(
                with: URL(string: model.imageURL),
                placeholder: UIImage(named: "no-image"),
                options: [
                    .processor(processor),
                    .cacheSerializer(WebPSerializer.default),
                    .loadDiskFileSynchronously,
                    .cacheOriginalImage,
                    .transition(.fade(0.26))
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
}

// MARK: SwipeableCardsViewDataSource
extension AnimeCardsView: SwipeableCardsViewDataSource {
    func swipeableCardsNumberOfItems(_ collectionView: SwipeableCardsView) -> Int {
        return animes.isEmpty ? 10 : animes.count
    }

    func swipeableCardsView(_ : SwipeableCardsView, viewForIndex index: Int) -> SwipeableCard {
        var swipeableCard = SwipeableCard()
        if animes.isEmpty {
            swipeableCard.backgroundColor = UIColor.Illustration.highlight
            swipeableCard.layer.cornerRadius = 8
            swipeableCard.clipsToBounds = true
        } else {
            let anime = animes[index]
            let topAnime = Common.createAnimeModel(with: anime)
            swipeableCard = buildSwipeableCard(using: topAnime)
        }
        return swipeableCard
    }
}

// MARK: SwipeableCardsViewDelegate
extension AnimeCardsView: SwipeableCardsViewDelegate {
    func swipeableCardsView(_ : SwipeableCardsView, didSelectItemAtIndex index: Int) {
        delegate?.didSelectItem(at: index)
    }
}

// MARK: Configuration
extension AnimeCardsView {
    func cardsUpdate(with model: [Jikan.AnimeDetails]) {
        animes = model
        cardsView.dataSource = self
        cardsView.delegate = self
        addSubview(cardsView)
        sendSubviewToBack(cardsView)
        cardsView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        cardsView.reloadData()
        UIView.transition(
            with: cardsView,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
}

