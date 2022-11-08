//
//  ScheduleCellView.swift
//  Tantei
//
//  Created by Randell on 7/11/22.
//

import Foundation
import UIKit
 
class ScheduleCellView: UICollectionViewCell {
     
    private lazy var metaDataStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        stackView.backgroundColor = UIColor("#242629", alpha: 0.6)
        stackView.layer.masksToBounds = false
        stackView.layer.shadowOpacity = 0.30
        stackView.layer.shadowRadius = 4
        stackView.layer.shadowOffset = CGSize(width: 0, height: 4)
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.cornerRadius = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.bold?.withSize(24)
        label.textColor = UIColor.Illustration.highlight
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.semiBold?.withSize(21)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.create(frame: frame)
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        titleLabel.sizeToFit()
        titleLabel.layoutIfNeeded()
    }
     
    private func create(frame: CGRect) {
        metaDataStackView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(8)
        }
        metaDataStackView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalTo(timeLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(8)
        }
        contentView.addSubview(metaDataStackView)
        metaDataStackView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView)
            $0.leading.trailing.equalTo(contentView)
        }
    }
}
