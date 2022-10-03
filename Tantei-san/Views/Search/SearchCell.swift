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
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 0
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
    
    private lazy var similarityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.medium?.withSize(42)
        label.textColor = UIColor.Illustration.highlight
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.medium?.withSize(18)
        label.textColor = UIColor.Elements.cardHeading
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()

    private lazy var episodeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.regular?.withSize(14)
        label.textColor = UIColor.Elements.cardParagraph
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private lazy var timestampLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.medium?.withSize(14)
        label.textColor = UIColor.Elements.cardParagraph
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private lazy var metaDataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
    }
}

// MARK: Setup UI
private extension SearchCell {
    func configureLayout() {
        contentView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-12)
            $0.left.equalToSuperview()
        }
        
        contentStackView.addSubview(similarityLabel)
        similarityLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(contentStackView.snp.leading).offset(16)
        }
        contentStackView.addSubview(metaDataStackView)
        metaDataStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalTo(contentStackView.snp.trailing).offset(-16)
            $0.bottom.equalTo(contentStackView.snp.bottom).offset(-8)
            $0.leading.equalTo(similarityLabel.snp.trailing).offset(16)
        }
        
        metaDataStackView.addArrangedSubview(titleLabel)
        metaDataStackView.addArrangedSubview(episodeLabel)
        metaDataStackView.addArrangedSubview(timestampLabel)
    }
}

// MARK: Configuration
extension SearchCell {
    func configure(viewModel: Trace.AnimeResult) {
        guard let id = viewModel.anilist.idMal,
              let title = viewModel.anilist.title else {
            return
        }
        let similarity = (viewModel.similarity ?? 0) * 100
        let episode = viewModel.episode ?? 1
        let from = (viewModel.from ?? 0).getMinutes()
        let to = (viewModel.to ?? 0).getMinutes()
        let labelTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(onCellTap(_:))
        )
        tag = id
        isUserInteractionEnabled = true
        addGestureRecognizer(labelTapGesture)
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        similarityLabel.text = formatter.string(from: similarity as NSNumber)
        titleLabel.text = title.english == nil ? title.romaji : title.english
        episodeLabel.text = "Episode \(episode)"
        timestampLabel.text = "\(from) - \(to)"
    }
}

// MARK: Actions
extension SearchCell {
    @objc func onCellTap(_ sender: UITapGestureRecognizer) {
        guard let id = sender.view?.tag else { return }
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: .curveEaseIn,
            animations: {
                self.isUserInteractionEnabled = false
                self.transform = CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.97)
            }
        ) { finished in
            UIView.animate(
                withDuration: 0.2,
                delay: 0.0,
                options: .curveEaseOut,
                animations: {
                    self.isUserInteractionEnabled = true
                    self.transform = CGAffineTransform.identity
                    print("Go to anime: \(id)")
                }
            )
        }
    }
}
