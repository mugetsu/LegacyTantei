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
        stackView.distribution = .fillProportionally
        stackView.spacing = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 10.0
        return stackView
    }()

    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        imageView.image = #imageLiteral(resourceName: "no-image")
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Custom.medium?.withSize(18)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Custom.regular?.withSize(14)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
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
        let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        contentView.frame = contentView.frame.inset(by: insets)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.cardImageView.image = nil
        self.titleLabel.text = nil
    }
}

// MARK: - Setup UI
private extension SearchCell {
    func configureLayout() {
        contentView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        mainStackView.addArrangedSubview(cardImageView)
        cardImageView.snp.makeConstraints {
            $0.width.equalTo(160.0)
            $0.height.equalTo(112.5)
        }

        mainStackView.addArrangedSubview(contentStackView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
        }
    }
}

// MARK: - Configuration
extension SearchCell {
    func configure(viewModel: Trace.AnimeResult) {
        guard let title = viewModel.anilist.title,
              let episode = viewModel.episode else {
            return
        }
        titleLabel.text = title.romaji
        descriptionLabel.text = "Episode \(episode)"
        guard let imageURL = viewModel.image else { return }
        cardImageView.kf.setImage(
            with: URL(string: imageURL),
            placeholder: #imageLiteral(resourceName: "no-image")
        )
    }
}
