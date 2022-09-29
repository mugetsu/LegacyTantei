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
        imageView.image = #imageLiteral(resourceName: "no-image")
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .black
        label.numberOfLines = 4
        return label
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .white
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        backgroundColor = .white

        contentView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16.0)
        }

        mainStackView.addArrangedSubview(cardImageView)
        cardImageView.snp.makeConstraints {
            $0.width.equalTo(160.0)
            $0.height.equalTo(112.5)
        }

        mainStackView.addArrangedSubview(contentStackView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
    }
}

// MARK: - Configuration
extension SearchCell {
    func configure(viewModel: AnimeResult) {
        self.titleLabel.text = viewModel.anilist.title.english
        self.descriptionLabel.text = viewModel.filename
        guard let imageURL = URL(string: viewModel.image) else { return }
        self.cardImageView.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "no-image"))
    }
}
