//
//  DetailView.swift
//  Tantei
//
//  Created by Randell on 12/10/22.
//

import Combine
import SnapKit
import UIKit

final class DetailView: UIViewController {
    private let viewModel: DetailViewModel
    private var uiEvent = PassthroughSubject<DetailEvents.UIEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    required init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.bind(uiEvent.eraseToAnyPublisher())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case let .fetchSuccess(detail, episodes):
                    self.titleLabel.text = detail.title
                    self.ratingTextView.text = detail.rating.tag
                    self.ratingTextView.textColor = detail.rating.color
                    self.ratingTextView.layer.borderColor = detail.rating.color.cgColor
                    self.synopsisLabel.text = detail.synopsis
                    episodes.forEach { episode in
                        let episodeTitleLabel: UILabel = {
                            let label = UILabel(frame: .zero)
                            label.font = UIFont.Custom.medium?.withSize(17)
                            label.textColor = UIColor.Elements.cardParagraph
                            label.numberOfLines = 0
                            label.text = episode.title
                            label.textAlignment = .left
                            label.translatesAutoresizingMaskIntoConstraints = false
                            return label
                        }()
                        self.episodesStackView.addArrangedSubview(episodeTitleLabel)
                    }
                    self.spinnerView.stopAnimating()
                    self.episodesLabel.text = episodes.count > 1
                        ? "Latest \(episodes.count) Episodes"
                        : "Latest Episode"
                    self.contentView.isHidden = false
                case .fetchFailed:
                    break
                }
            }.store(in: &cancellables)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var spinnerView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.backgroundColor = .clear
        view.color = .white
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        view.isHidden = true
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
        textView.isScrollEnabled = false
        textView.sizeToFit()
        textView.backgroundColor = .clear
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(onExpand))
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(tap)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var episodesLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.bold?.withSize(21)
        label.textColor = UIColor.Elements.headline
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var episodesStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 7
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        spinnerView.startAnimating()
        uiEvent.send(.viewDidLoad)
    }
    
    func configureLayout() {
        view.backgroundColor = UIColor.Elements.backgroundLight
        
        view.addSubview(spinnerView)
        spinnerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        headerStackView.addArrangedSubview(titleLabel)
        metaDataStackView.addArrangedSubview(ratingTextView)
        headerStackView.addArrangedSubview(metaDataStackView)
        view.addSubview(headerStackView)
        headerStackView.snp.makeConstraints {
            $0.top.equalTo(view).offset(24)
            $0.leading.trailing.equalTo(view).inset(24)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom).offset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(0)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(0)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(0)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(0)
            $0.bottom.equalTo(scrollView.snp.bottom).offset(0)
            $0.leading.equalTo(scrollView.snp.leading).offset(0)
            $0.trailing.equalTo(scrollView.snp.trailing).offset(0)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        synopsisStackView.addArrangedSubview(synopsisLabel)
        synopsisStackView.addArrangedSubview(expandButton)
        contentView.addSubview(synopsisStackView)
        
        episodesStackView.addArrangedSubview(episodesLabel)
        episodesStackView.addArrangedSubview(UIView.spacer(size: 2, for: .vertical))
        contentView.addSubview(episodesStackView)
        
        contentView.subviews.enumerated().forEach { (index, item) in
            item.snp.makeConstraints { make in
                let isStartIndex = index == contentView.subviews.startIndex
                let isEndIndex = index == (contentView.subviews.endIndex - 1)
                let previousIndex = isStartIndex ? 0 : (index - 1)
                let previousItem = isStartIndex
                    ? contentView.snp.top
                    : contentView.subviews[previousIndex].snp.bottom
                make.top.equalTo(previousItem).offset(isStartIndex ? 0 : 16)
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
