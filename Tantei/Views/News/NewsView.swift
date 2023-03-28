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
        setCustomSpacing(10, after: titleLabel)
    }
    
    func configureList() {
        for (index, item) in news.enumerated() {
            let titleButton: UIButton = {
                let button = UIButton(frame: .zero)
                button.backgroundColor = .clear
                button.setTitleColor(UIColor.Illustration.highlight, for: .normal)
                button.contentHorizontalAlignment = .left
                button.tag = index
                button.setTitle(item.title ?? "", for: .normal)
                button.titleLabel?.font = UIFont.Custom.medium?.withSize(17)
                button.addTarget(self, action: #selector(onTap(_:)), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
            let excerptLabel: UILabel = {
                let label = UILabel(frame: .zero)
                label.font = UIFont.Custom.medium?.withSize(14)
                label.textColor = UIColor.Elements.cardParagraph
                label.numberOfLines = 3
                label.text = item.excerpt ?? ""
                label.sizeToFit()
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            let contentWrapper: UIStackView = {
                let view  = UIStackView()
                view.axis = .vertical
                view.spacing = 0
                view.alignment = .top
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            contentWrapper.addArrangedSubview(titleButton)
            contentWrapper.addArrangedSubview(excerptLabel)
            addArrangedSubview(contentWrapper)
            contentWrapper.snp.makeConstraints {
                $0.trailing.leading.equalToSuperview()
            }
        }
    }
}

// MARK: Actions
extension NewsView {
    @objc func onTap(_ sender: UIButton) {
        guard let stringURL = news[sender.tag].url,
              let url = URL(string: stringURL) else {
            return
        }
        UIApplication.shared.open(url)
    }
}

// MARK: Configuration
extension NewsView {
    func update(with model: [Jikan.AnimeNews]) {
        news = model
        configureLayout()
    }
}
