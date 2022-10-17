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

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.bold?.withSize(26)
        label.textColor = UIColor.Elements.headline
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tagsStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 4
        stackView.setContentHuggingPriority(.required, for: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var synopsisView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = UIFont.Custom.medium?.withSize(18)
        textView.textColor = UIColor.Elements.cardParagraph
        textView.backgroundColor = .clear
        textView.isSelectable = true
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        configureContentView()
        configureData(using: anime)
        configureLayout()
    }
    
    func configureData(using model: Anime) {
        titleLabel.text = model.title
        model.genres.forEach { genre in
            let genreLabel: UILabel = {
                let label = UILabel(frame: .zero)
                label.font = UIFont.Custom.bold?.withSize(14)
                label.textColor = UIColor.Elements.headline
                label.numberOfLines = 0
                label.backgroundColor = UIColor.Illustration.highlight
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            genreLabel.text = genre.rawValue
            tagsStackView.addArrangedSubview(genreLabel)
        }
        synopsisView.isScrollEnabled = true
        synopsisView.text = model.synopsis
        synopsisView.sizeToFit()
        synopsisView.isScrollEnabled = false
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(0)
            $0.leading.equalTo(view).offset(0)
            $0.trailing.equalTo(view).offset(0)
        }
    }
    
    func configureContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView).offset(0)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
    }
    
    func configureLayout() {
        view.backgroundColor = UIColor.Elements.backgroundDark
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
        }
        
        contentView.addSubview(tagsStackView)
        tagsStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        contentView.addSubview(synopsisView)
        synopsisView.snp.makeConstraints {
            $0.top.equalTo(tagsStackView.snp.bottom).offset(16)
        }
        
        contentView.subviews.enumerated().forEach { (index, item) in
            item.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                if index == (contentView.subviews.endIndex - 1) {
                    make.bottom.equalTo(contentView.snp.bottom).offset(0)
                }
            }
        }
    }
}
