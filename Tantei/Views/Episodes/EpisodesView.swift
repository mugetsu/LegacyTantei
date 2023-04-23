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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.registerCell(cellClass: CustomCellView.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.Elements.backgroundLight
        tableView.separatorColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var selectedCell: IndexPath?
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
            let episodeNumber = (episode.malId ?? 0).zeroPrefixed()
            let episodeScore = (episode.score ?? 0).formatScore()
            let numberLabel: UILabel = {
                let label = UILabel(frame: .zero)
                label.font = UIFont.Custom.regular?.withSize(17)
                label.textColor = .white
                label.numberOfLines = 0
                label.text = episodeNumber
                label.textAlignment = .left
                label.sizeToFit()
                label.setContentCompressionResistancePriority(.init(999), for: .horizontal)
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
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
            let scoreLabel: UILabel = {
                let label = UILabel(frame: .zero)
                label.font = UIFont.Custom.regular?.withSize(14)
                label.textColor = episodeScore == "N/A"
                    ? UIColor.Elements.subHeadline.withAlphaComponent(0.8)
                    : UIColor.Illustration.tertiary
                label.numberOfLines = 0
                label.text = episodeScore
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
            contentWrapper.addArrangedSubview(numberLabel)
            contentWrapper.addArrangedSubview(titleLabel)
            contentWrapper.addArrangedSubview(UIView())
            contentWrapper.addArrangedSubview(UIView.spacer(size: 8, for: .horizontal))
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
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension EpisodesView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
}

// MARK: UITableViewDelegate
extension EpisodesView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: CustomCellView.self, indexPath: indexPath)
        let episode = episodes[indexPath.row]
        cell.configure(using: SearchResult(title: episode.title ?? "TEST", matchPercent: "", episode: "", timestamp: episode.aired ?? ""))
        return cell
    }
}

final class CustomCellView: UITableViewCell {
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.backgroundColor = UIColor.Elements.cardBackground
        stackView.layer.masksToBounds = false
        stackView.layer.shadowOpacity = 0.30
        stackView.layer.shadowRadius = 4
        stackView.layer.shadowOffset = CGSize(width: 0, height: 4)
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.cornerRadius = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.medium?.withSize(26)
        label.textColor = UIColor.Elements.cardHeading
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var episodeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.medium?.withSize(16)
        label.textColor = UIColor.Illustration.highlight
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timestampLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.medium?.withSize(14)
        label.textColor = UIColor.Elements.cardParagraph
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var metaDataStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var similarityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.medium?.withSize(26)
        label.textColor = UIColor.Illustration.tertiary
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var similarityStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.setContentHuggingPriority(.required, for: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
        self.episodeLabel.text = nil
        self.timestampLabel.text = nil
        self.similarityLabel.text = nil
    }
}

// MARK: Setup UI
private extension CustomCellView {
    func configureLayout() {
        addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.0)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
        metaDataStackView.addArrangedSubview(titleLabel)
        metaDataStackView.addArrangedSubview(episodeLabel)
        metaDataStackView.addArrangedSubview(timestampLabel)
        contentStackView.addArrangedSubview(metaDataStackView)
        metaDataStackView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentStackView).inset(8.0)
        }
        metaDataStackView.subviews.forEach {
            $0.snp.makeConstraints { make in
                make.leading.equalTo(metaDataStackView).inset(16.0)
            }
        }
        similarityStackView.addArrangedSubview(similarityLabel)
        contentStackView.addArrangedSubview(similarityStackView)
        similarityStackView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentStackView).inset(8.0)
        }
        similarityStackView.subviews.forEach {
            $0.snp.makeConstraints { make in
                make.trailing.equalTo(similarityStackView).inset(16.0)
            }
        }
        layoutIfNeeded()
    }
}

// MARK: Configuration
extension CustomCellView {
    func configure(using model: SearchResult) {
        titleLabel.text = model.title
        episodeLabel.text = model.episode
        timestampLabel.text = model.timestamp
        similarityLabel.text = model.matchPercent
    }
}
