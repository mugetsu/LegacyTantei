//
//  DetailView.swift
//  Tantei-san
//
//  Created by Randell on 12/10/22.
//

import UIKit
import SnapKit

final class DetailView: UIViewController {
    internal let anime: Anime
    
    required init(anime: Anime) {
        self.anime = anime
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var metaDataStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.bold?.withSize(28)
        label.textColor = UIColor.Elements.headline
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = UIFont.Custom.medium?.withSize(12)
        textView.textColor = UIColor.Elements.cardParagraph
        textView.isScrollEnabled = false
        textView.sizeToFit()
        textView.backgroundColor = .clear
        textView.layer.borderColor = UIColor.Elements.cardParagraph.cgColor
        textView.layer.borderWidth = 1.0
        textView.textContainerInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var synopsisLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.medium?.withSize(17)
        label.textColor = UIColor.Elements.cardParagraph
        label.numberOfLines = 4
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var expandButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor.Illustration.highlight, for: .normal)
        button.setTitle("read more", for: .normal)
        button.titleLabel?.font = UIFont.Custom.medium?.withSize(17)
        button.addTarget(self, action: #selector(onExpand), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var synopsisStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureData(using: anime)
        configureLayout()
    }
    
    func configureData(using model: Anime) {
        titleLabel.text = model.title
        ratingTextView.text = model.rating.tag
        synopsisLabel.text = model.synopsis
    }
    
    func configureLayout() {
        view.backgroundColor = UIColor.Elements.backgroundDark
        
        view.addSubview(headerStackView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        headerStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            $0.leading.trailing.equalTo(view).inset(24)
        }
        
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(metaDataStackView)
        metaDataStackView.addArrangedSubview(ratingTextView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom).offset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(0)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(0)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(0)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(0)
            $0.bottom.equalTo(scrollView.snp.bottom).offset(0)
            $0.leading.equalTo(scrollView.snp.leading).offset(0)
            $0.trailing.equalTo(scrollView.snp.trailing).offset(0)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        synopsisStackView.addArrangedSubview(synopsisLabel)
        
        if (synopsisLabel.text?.count ?? 0) > 164 {
            synopsisStackView.addArrangedSubview(expandButton)
        }
        
        contentView.addSubview(synopsisStackView)
        
        contentView.subviews.enumerated().forEach { (index, item) in
            item.snp.makeConstraints { make in
                let isStartIndex = index == contentView.subviews.startIndex
                let isEndIndex = index == (contentView.subviews.endIndex - 1)
                make.top.equalToSuperview().offset(isStartIndex ? 0 : 16)
                make.leading.trailing.equalToSuperview().inset(24)
                if isEndIndex {
                    make.bottom.equalTo(contentView.snp.bottom).offset(0)
                }
            }
        }
    }
}

extension DetailView {
    @objc func onExpand() {
        let isExpanded = self.synopsisLabel.numberOfLines == 0
        self.synopsisLabel.numberOfLines = isExpanded ? 4 : 0
        self.expandButton.setTitle(isExpanded ? "read more" : "read less", for: .normal)
        self.synopsisLabel.superview?.layoutIfNeeded()
    }
}
