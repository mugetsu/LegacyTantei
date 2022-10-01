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
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()

    private lazy var titleLabel: XLabel = {
        let label = XLabel()
        label.font = UIFont.Custom.medium?.withSize(18)
        label.textColor = .black
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        return label
    }()

    private lazy var episodeLabel: XLabel = {
        let label = XLabel()
        label.font = UIFont.Custom.regular?.withSize(16)
        label.textColor = .gray
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var timestampLabel: XLabel = {
        let label = XLabel()
        label.font = UIFont.Custom.bold?.withSize(16)
        label.textColor = .gray
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var metaDataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.30
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowColor = UIColor.black.cgColor
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 4
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let insets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        contentView.frame = contentView.frame.inset(by: insets)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
    }
}

// MARK: Setup UI
private extension SearchCell {
    func configureLayout() {
        contentView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainStackView.addArrangedSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(14)
        }
        
        contentStackView.addArrangedSubview(metaDataStackView)
        metaDataStackView.snp.makeConstraints {
            $0.leading.equalTo(contentStackView.snp.leading).offset(16)
            $0.trailing.equalTo(contentStackView.snp.trailing).offset(-16)
        }
        
        metaDataStackView.addArrangedSubview(titleLabel)
        metaDataStackView.addArrangedSubview(episodeLabel)
        metaDataStackView.addArrangedSubview(timestampLabel)
        timestampLabel.snp.makeConstraints {
            $0.top.equalTo(episodeLabel.snp.bottom).offset(-8)
        }
    }
}

// MARK: Configuration
extension SearchCell {
    func configure(viewModel: Trace.AnimeResult) {
        guard let id = viewModel.anilist.idMal,
              let title = viewModel.anilist.title else {
            return
        }
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
