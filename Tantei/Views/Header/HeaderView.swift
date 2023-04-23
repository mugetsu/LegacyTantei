//
//  HeaderView.swift
//  Tantei
//
//  Created by Randell on 30/10/22.
//

import Foundation
import SnapKit
import UIKit

final class HeaderView: UIView {
    private lazy var wrapperView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .horizontal
        view.spacing = 0
        view.alignment = .top
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "detective-purple")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.font = UIFont.Custom.extraBold?.withSize(34)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init(model: HeaderDetail) {
        super.init(frame: .zero)
        configure(using: model)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI Setup
private extension HeaderView {
    func configureLayout() {
        addSubview(wrapperView)
        wrapperView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        wrapperView.addArrangedSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.trailing.leading.equalToSuperview()
        }
        contentView.addArrangedSubview(titleLabel)
        contentView.addArrangedSubview(UIView())
        contentView.addArrangedSubview(imageView)
        imageView.snp.makeConstraints {
            $0.width.equalTo(32)
            $0.height.equalTo(32)
        }
    }
}

// MARK: Configuration
extension HeaderView {
    func configure(using model: HeaderDetail) {
        titleLabel.text = model.title
    }
}
