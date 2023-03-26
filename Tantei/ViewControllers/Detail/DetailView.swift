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
                    self.synopsisView.update(with: detail.synopsis)
                    self.episodesView.update(with: episodes)
                    self.isLoading = false
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
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.sizeToFit()
        textView.backgroundColor = .clear
        textView.layer.borderWidth = 1.0
        textView.textContainerInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var synopsisView: SynopsisView = {
        let view = SynopsisView(synopsis: "")
        return view
    }()
    
    private lazy var episodesView: EpisodesView = {
        let view = EpisodesView(episodes: [])
        return view
    }()
    
    private var isLoading: Bool = true {
        didSet {
            if isLoading {
                spinnerView.startAnimating()
            } else {
                spinnerView.stopAnimating()
            }
            headerStackView.isHidden = isLoading
            contentView.isHidden = isLoading
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        isLoading = true
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
        
        contentView.addSubview(synopsisView)
        
        contentView.addSubview(episodesView)
        
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
