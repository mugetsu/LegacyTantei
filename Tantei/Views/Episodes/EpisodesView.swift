//
//  EpisodesView.swift
//  Tantei
//
//  Created by Randell Quitain on 26/3/23.
//

import SnapKit
import UIKit

final class EpisodesView: UIStackView {
    
    var episodes: [Jikan.AnimeEpisode] = []
    
    required init(episodes: [Jikan.AnimeEpisode]) {
        self.episodes = episodes
        super.init(frame: .zero)
        configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.bold?.withSize(21)
        label.textColor = UIColor.Elements.headline
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

// MARK: UI Setup
private extension EpisodesView {
    func configureLayout() {
        guard episodes.count != 0 else {
            isHidden = true
            return
        }
        isHidden = false
        axis = .vertical
        alignment = .top
        distribution = .fill
        spacing = 8
        translatesAutoresizingMaskIntoConstraints = false
        configureTitle()
        configureList()
    }
    
    func configureTitle() {
        titleLabel.text = episodes.count > 1
            ? "Latest \(episodes.count) Episodes"
            : "Latest Episode"
        addArrangedSubview(titleLabel)
        setCustomSpacing(16, after: titleLabel)
    }
    
    func configureList() {
        episodes.forEach { episode in
            let episodeTitleText = episode.title
            let episodeNumber = episode.malId ?? 0
            let episodeNumberText = String(format: "%02d", episodeNumber)
            let episodeScore = episode.score ?? 0
            let episodeScoreText = String(format: "%.1f★", episodeScore)
            let titleLabel: UILabel = {
                let label = UILabel(frame: .zero)
                label.font = UIFont.Custom.medium?.withSize(17)
                label.textColor = UIColor.Elements.cardParagraph
                label.numberOfLines = 0
                label.text = episodeTitleText
                label.textAlignment = .left
                label.setContentCompressionResistancePriority(.init(999), for: .horizontal)
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            let numberLabel: UILabel = {
                let label = UILabel(frame: .zero)
                label.font = UIFont.Custom.regular?.withSize(14)
                label.textColor = UIColor.Elements.subHeadline.withAlphaComponent(0.8)
                label.numberOfLines = 0
                label.text = episodeNumberText
                label.textAlignment = .left
                label.sizeToFit()
                label.setContentCompressionResistancePriority(.init(999), for: .horizontal)
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            let scoreLabel: UILabel = {
                let label = UILabel(frame: .zero)
                label.font = UIFont.Custom.regular?.withSize(14)
                label.textColor = episodeScore == 0
                    ? UIColor.Elements.subHeadline.withAlphaComponent(0.8)
                    : UIColor.Illustration.tertiary
                label.numberOfLines = 0
                label.text = episodeScore == 0
                    ? "X.X★"
                    : episodeScoreText
                label.textAlignment = .left
                label.sizeToFit()
                label.setContentCompressionResistancePriority(.init(999), for: .horizontal)
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            let contentWrapper: UIStackView = {
                let view  = UIStackView()
                view.axis = .horizontal
                view.spacing = 8
                view.alignment = .center
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            contentWrapper.addArrangedSubview(titleLabel)
            contentWrapper.addArrangedSubview(UIView())
            contentWrapper.addArrangedSubview(UIView.spacer(size: 8, for: .horizontal))
            contentWrapper.addArrangedSubview(numberLabel)
            contentWrapper.addArrangedSubview(scoreLabel)
            addArrangedSubview(contentWrapper)
            contentWrapper.snp.makeConstraints {
                $0.trailing.leading.equalToSuperview()
            }
        }
    }
}

// MARK: Configuration
extension EpisodesView {
    func update(with model: [Jikan.AnimeEpisode]) {
        episodes = model
        configureLayout()
    }
}
