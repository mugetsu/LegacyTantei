//
//  DashboardView.swift
//  Tantei
//
//  Created by Randell on 1/10/22.
//

import Combine
import SnapKit
import UIKit

class DashboardView: UIViewController, DashboardBaseCoordinated {
    private let viewModel: DashboardViewModel
    var coordinator: DashboardBaseCoordinator?
    
    private var uiEvent = PassthroughSubject<DashboardEvents.UIEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    required init(viewModel: DashboardViewModel, coordinator: DashboardBaseCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        viewModel.bind(uiEvent.eraseToAnyPublisher())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case let .fetchSuccess(topAnimes):
                    self.topAnimeCardsView.cardsUpdate(with: topAnimes)
                case .fetchFailed:
                    print("Something went wrong.")
                case let .showAnimeDetails(details):
                    self.presentModal(with: details)
                case let .showUpdatedTopAnimes(topAnimes):
                    self.spinnerView.stopAnimating()
                    self.topAnimeCardsView.cardsUpdate(with: topAnimes)
                    self.categoryView.isUserInteractionEnabled = true
                    UIView.transition(
                        with: self.topAnimeCardsView,
                        duration: 0.4,
                        options: .transitionCrossDissolve
                    ) {
                        self.topAnimeCardsView.alpha = 1
                    }
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

    private lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerView: HeaderView = {
        let view = HeaderView(model: .init(
            title: viewModel.getGreeting()
        ))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var topAnimeView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var topAnimeTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.font = UIFont.Custom.regular?.withSize(16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Check out"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryView: CategoryCardsView = {
        let titles = viewModel.getCategories()
        let view = CategoryCardsView(titles: titles + titles)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var topAnimeCardsView: AnimeCardsView = {
        let view = AnimeCardsView(animes: [])
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cardHeight: Int = 337
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        configureView()
        uiEvent.send(.viewDidLoad)
    }
}

// MARK: UI Setup
private extension DashboardView {
    func setupNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func configureView() {
        view.backgroundColor = UIColor.Elements.backgroundDark
        
        view.addSubview(spinnerView)
        spinnerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        contentView.addSubview(headerView)
        topAnimeView.addSubview(topAnimeTitleLabel)
        topAnimeTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
        }
        topAnimeView.addSubview(categoryView)
        categoryView.snp.makeConstraints {
            $0.top.equalTo(topAnimeTitleLabel.snp.bottom)
            $0.leading.equalTo(topAnimeView)
            $0.trailing.equalTo(topAnimeView)
        }
        topAnimeView.addSubview(topAnimeCardsView)
        topAnimeCardsView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.top.equalTo(categoryView.snp.bottom)
            $0.leading.trailing.equalTo(topAnimeView)
        }
        contentView.addSubview(topAnimeView)
        topAnimeView.snp.makeConstraints {
            $0.height.equalTo(cardHeight)
        }
        
        contentView.subviews.enumerated().forEach { (index, item) in
            item.snp.makeConstraints { make in
                let isStartIndex = index == contentView.subviews.startIndex
                let isEndIndex = index == (contentView.subviews.endIndex - 1)
                let previousIndex = isStartIndex ? 0 : (index - 1)
                let previousItem = isStartIndex
                    ? contentView.snp.top
                    : contentView.subviews[previousIndex].snp.bottom
                make.top.equalTo(previousItem).offset(isStartIndex ? 0 : 16)
                make.leading.trailing.equalToSuperview().inset(16)
                if isEndIndex {
                    make.bottom.equalTo(contentView.snp.bottom).offset(0)
                }
            }
        }
    }
}

// MARK: Actions
extension DashboardView {
    private func presentModal(with anime: Anime) {
        let detailView = DetailView(
            viewModel: DetailViewModel(detail: anime)
        )
        let navigationController = UINavigationController(rootViewController: detailView)
        navigationController.modalPresentationStyle = .pageSheet
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: CategoryCardsViewDelegate
extension DashboardView: CategoryCardsViewDelegate {
    func didSelect(label text: String) {
        var selectedCategory: Jikan.TopAnimeType = .airing
        switch text {
        case Jikan.TopAnimeType.upcoming.description:
            selectedCategory = .upcoming
        case Jikan.TopAnimeType.popular.description:
            selectedCategory = .popular
        case Jikan.TopAnimeType.favorite.description:
            selectedCategory = .favorite
        default:
            selectedCategory = .airing
        }
        spinnerView.startAnimating()
        topAnimeCardsView.alpha = 0
        categoryView.isUserInteractionEnabled = false
        uiEvent.send(.changedCategory(selectedCategory))
    }
}

// MARK: AnimeCardsViewDelegate
extension DashboardView: AnimeCardsViewDelegate {
    func didSelectItem(at index: Int) {
        uiEvent.send(.getAnimeDetails(index: index))
    }
}
