//
//  CategoryCardsView.swift
//  Tantei
//
//  Created by Randell on 1/11/22.
//

import SnapKit
import UIKit

class CategoryCardsView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(stackView)
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    var titles: [String] = []
    
    required init(titles: [String]) {
        self.titles = titles
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI Setup
private extension CategoryCardsView {
    func configureView() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.snp.makeConstraints {
            $0.height.equalTo(scrollView.snp.height)
            $0.top.equalTo(scrollView.snp.top)
            $0.leading.trailing.equalTo(scrollView)
        }
        titles.enumerated().forEach { index, title in
            let titleLabel: UILabel = {
                let label = UILabel()
                label.text = title
                label.font = UIFont.Custom.bold?.withSize(34)
                label.textColor = index == 0
                    ? UIColor("#7f5af0")
                    : UIColor("#7f5af0", alpha: 0.2)
                label.textAlignment = .left
                label.setContentHuggingPriority(.defaultLow, for: .horizontal)
                label.setContentCompressionResistancePriority(.required, for: .horizontal)
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            stackView.addArrangedSubview(titleLabel)
        }
    }
}
