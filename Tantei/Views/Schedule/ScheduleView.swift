//
//  ScheduleView.swift
//  Tantei
//
//  Created by Randell on 6/11/22.
//

import SnapKit
import UIKit

final class ScheduleView: UIStackView {
    
    var animes: [Jikan.AnimeDetails] = []
    
    required init(animes: [Jikan.AnimeDetails]) {
        self.animes = animes
        super.init(frame: .zero)
        configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.regular?.withSize(16)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "For today's anime"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.bold?.withSize(34)
        label.textColor = UIColor.Illustration.highlight
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Schedule"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var headerStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [subtitleLabel, titleLabel])
        view.axis = .vertical
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

// MARK: UI Setup
private extension ScheduleView {
    func configureLayout() {
        guard animes.count != 0 else {
            isHidden = true
            return
        }
        isHidden = false
        axis = .vertical
        alignment = .top
        distribution = .fill
        spacing = 16
        translatesAutoresizingMaskIntoConstraints = false
        configureTitle()
        configureList()
    }
    
    func configureTitle() {
        addArrangedSubview(headerStackView)
        setCustomSpacing(16, after: headerStackView)
    }
    
    func configureList() {
        animes.forEach { anime in
            let model = Common.createAnimeModel(with: anime)
            let broadcastLabel: UILabel = {
                let label = UILabel(frame: .zero)
                label.font = UIFont.Custom.regular?.withSize(21)
                label.textColor = .white
                label.numberOfLines = 0
                label.text = anime.broadcast?.time ?? "00:00"
                label.textAlignment = .left
                label.sizeToFit()
                label.setContentCompressionResistancePriority(.init(999), for: .horizontal)
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            let animeTitleLabel: UILabel = {
                let label = UILabel(frame: .zero)
                label.font = UIFont.Custom.medium?.withSize(21)
                label.textColor = UIColor.Elements.cardParagraph
                label.numberOfLines = 0
                label.text = anime.title
                label.textAlignment = .left
                label.setContentCompressionResistancePriority(.init(999), for: .horizontal)
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            let ratingTextView: UITextView = {
                let textView = UITextView(frame: .zero)
                textView.text = model.rating.tag
                textView.textColor = model.rating.color
                textView.layer.borderColor = model.rating.color.cgColor
                textView.font = UIFont.Custom.medium?.withSize(12)
                textView.isEditable = false
                textView.isSelectable = false
                textView.isScrollEnabled = false
                textView.sizeToFit()
                textView.backgroundColor = .clear
                textView.layer.borderWidth = 1.0
                textView.textContainerInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
                textView.setContentCompressionResistancePriority(.init(999), for: .horizontal)
                textView.translatesAutoresizingMaskIntoConstraints = false
                return textView
            }()
            let scoreLabel: UILabel = {
                let label = UILabel(frame: .zero)
                let score = model.score
                let scoreText = String(format: "%.1f★", score)
                label.font = UIFont.Custom.regular?.withSize(14)
                label.textColor = score == 0
                    ? UIColor.Elements.subHeadline.withAlphaComponent(0.8)
                    : UIColor.Illustration.tertiary
                label.numberOfLines = 0
                label.text = score == 0
                    ? "X.X★"
                    : scoreText
                label.textAlignment = .left
                label.sizeToFit()
                label.setContentCompressionResistancePriority(.init(999), for: .horizontal)
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            let detailsWrapper: UIStackView = {
                let view  = UIStackView()
                view.axis = .vertical
                view.spacing = 8
                view.alignment = .top
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            let metaDataWrapper: UIStackView = {
                let view  = UIStackView()
                view.axis = .horizontal
                view.spacing = 8
                view.alignment = .center
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            let contentWrapper: UIStackView = {
                let view  = UIStackView()
                view.axis = .horizontal
                view.spacing = 16
                view.alignment = .top
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            contentWrapper.addArrangedSubview(broadcastLabel)
            metaDataWrapper.addArrangedSubview(ratingTextView)
            metaDataWrapper.addArrangedSubview(scoreLabel)
            metaDataWrapper.addArrangedSubview(UIView())
            detailsWrapper.addArrangedSubview(animeTitleLabel)
            detailsWrapper.addArrangedSubview(metaDataWrapper)
            contentWrapper.addArrangedSubview(detailsWrapper)
            contentWrapper.addArrangedSubview(UIView())
            addArrangedSubview(contentWrapper)
            contentWrapper.snp.makeConstraints {
                $0.trailing.leading.equalToSuperview()
            }
        }
    }
}

// MARK: Configuration
extension ScheduleView {
    func update(with model: [Jikan.AnimeDetails]) {
        animes = model
        configureLayout()
    }
}
