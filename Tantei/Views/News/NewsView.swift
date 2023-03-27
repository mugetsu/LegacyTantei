//
//  NewsView.swift
//  Tantei
//
//  Created by Randell Quitain on 27/3/23.
//

import SnapKit
import UIKit

final class NewsView: UIStackView {
    
    var news: [Jikan.AnimeNews] = []
    
    required init(news: [Jikan.AnimeNews]) {
        self.news = news
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
private extension NewsView {
    func configureLayout() {
        guard news.count != 0 else {
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
        titleLabel.text = "Latest News"
        addArrangedSubview(titleLabel)
        setCustomSpacing(16, after: titleLabel)
    }
    
    func configureList() {
        news.forEach { item in
            let newsTitleText = item.title
            let newsTitleLabel: UILabel = {
                let label = UILabel(frame: .zero)
                label.font = UIFont.Custom.medium?.withSize(17)
                label.textColor = UIColor.Elements.cardParagraph
                label.numberOfLines = 0
                label.text = newsTitleText
                label.textAlignment = .left
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
            contentWrapper.addArrangedSubview(newsTitleLabel)
            addArrangedSubview(contentWrapper)
            contentWrapper.snp.makeConstraints {
                $0.trailing.leading.equalToSuperview()
            }
        }
    }
}

// MARK: Configuration
extension NewsView {
    func update(with model: [Jikan.AnimeNews]) {
        news = model
        configureLayout()
    }
}
