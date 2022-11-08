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
    private lazy var titleView: UIView = {
        let view = UIView(frame: .zero)
        view.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.font = UIFont.Custom.medium?.withSize(17)
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
        let topPadding = 64
        let bottomPadding = 16
        addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(titleView).offset(topPadding)
            $0.leading.trailing.equalTo(titleView)
            if (subTitleLabel.text == nil) {
                $0.bottom.equalTo(titleView).inset(bottomPadding)
            }
        }
        if (subTitleLabel.text != nil) {
            titleView.addSubview(subTitleLabel)
            subTitleLabel.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(4)
                $0.leading.trailing.equalTo(titleView)
                $0.bottom.equalTo(titleView).inset(bottomPadding)
            }
        }
    }
}

// MARK: Configuration
extension HeaderView {
    func configure(using model: HeaderDetail) {
        titleLabel.text = model.title
        subTitleLabel.text = model.subTitle
    }
}
