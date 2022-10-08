//
//  SearchCell.swift
//  Tantei-san
//
//  Created by Randell on 29/9/22.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class SearchCell: UITableViewCell {
    
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
        self.similarityLabel.text = nil
        self.titleLabel.text = nil
        self.episodeLabel.text = nil
        self.timestampLabel.text = nil
    }
}

// MARK: Setup UI
private extension SearchCell {
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
extension SearchCell {
    func configure(viewModel: Trace.AnimeDetails) {
        guard let title = viewModel.anilist.title else {
            return
        }
        let similarity = (viewModel.similarity ?? 0) * 100
        let episode = viewModel.episode ?? 1
        let from = (viewModel.from ?? 0).getMinutes()
        let to = (viewModel.to ?? 0).getMinutes()
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        let matchPercent = "\(formatter.string(from: similarity as NSNumber) ?? "0")%"
        similarityLabel.text = matchPercent
        similarityLabel.textColor = UIColor("#2cb67d", alpha: similarity < 90 ? 0.6 : 1.0)
        titleLabel.text = title.english == nil ? title.romaji : title.english
        episodeLabel.text = "Episode \(episode)"
        timestampLabel.text = "\(from) - \(to)"
    }
}
