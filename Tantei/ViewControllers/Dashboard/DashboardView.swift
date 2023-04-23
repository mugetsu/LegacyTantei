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
                case let .fetchSuccess(topAnimes, scheduledAnimesForToday):
                    self.topAnimeCardsView.update(with: topAnimes)
                    self.scheduleView.update(with: scheduledAnimesForToday)
                case .fetchFailed:
                    print("Something went wrong.")
                case let .showAnimeDetails(details):
                    self.presentModal(with: details)
                case let .showUpdatedTopAnimes(topAnimes):
                    self.topAnimeCardsView.update(with: topAnimes)
                    self.topAnimeCardsView.isLoading = false
                    self.categoryView.isUserInteractionEnabled = true
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
    
    private lazy var topView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var middleView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bottomView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var menuOverlayView: UIView = {
        let view = UIView()
        let swipeGesture = UISwipeGestureRecognizer(
            target: self,
            action: #selector(didSwipeRight)
        )
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapOverlay)
        )
        view.backgroundColor = .black
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var menuView: UIView = {
        let view = MenuView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerView: UIView = {
        let view = HeaderView(viewModel: HeaderViewModel())
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var topAnimeView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var topAnimeTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Custom.regular?.withSize(16)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Check out"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryView: CategoryCardsView = {
        var titles: [String] = []
        Jikan.TopAnimeType.allCases.forEach { type in
            titles.append(type.description)
        }
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
    
    private lazy var scheduleView: ScheduleView = {
        let view = ScheduleView(animes: [])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var isLoading: Bool = true {
        didSet {
            if isLoading {
                spinnerView.startAnimating()
            } else {
                spinnerView.stopAnimating()
            }
            contentView.isHidden = isLoading
        }
    }
    
    let cardHeight: Int = 337
    
    lazy var viewBounds: CGRect = view.bounds
    
    lazy var menuWidth: CGFloat = viewBounds.width * 2 / 3
    
    lazy var menuHeight: CGFloat = viewBounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        setupMenu()
        uiEvent.send(.viewDidLoad)
    }
}

// MARK: UI Setup
private extension DashboardView {
    func setupNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupView() {
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
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        topView.addArrangedSubview(headerView)
        
        topAnimeView.addArrangedSubview(topAnimeTitleLabel)
        topAnimeView.addArrangedSubview(categoryView)
        topAnimeView.addArrangedSubview(topAnimeCardsView)
        topAnimeCardsView.snp.makeConstraints {
            $0.height.equalTo(cardHeight)
        }
        
        middleView.addArrangedSubview(topAnimeView)
        
        bottomView.addArrangedSubview(scheduleView)
        
        contentView.addSubview(topView)
        topView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        contentView.addSubview(middleView)
        middleView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        contentView.subviews.enumerated().forEach { (index, item) in
            let topSpacing = 32
            let horizontalSpacing = 16
            item.snp.makeConstraints { make in
                let isStartIndex = index == contentView.subviews.startIndex
                let isEndIndex = index == (contentView.subviews.endIndex - 1)
                let previousIndex = isStartIndex ? 0 : (index - 1)
                let previousItem = isStartIndex
                    ? contentView.snp.top
                    : contentView.subviews[previousIndex].snp.bottom
                make.top.equalTo(previousItem).offset(
                    isStartIndex
                        ? topSpacing
                        : horizontalSpacing
                )
                if isEndIndex {
                    make.bottom.equalTo(contentView.snp.bottom).offset(0)
                }
            }
        }
    }
    
    func setupMenu() {
        view.addSubview(menuOverlayView)
        view.bringSubviewToFront(menuOverlayView)
        menuOverlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        view.addSubview(menuView)
        view.bringSubviewToFront(menuView)
        menuView.snp.makeConstraints {
            $0.left.equalTo(viewBounds.width)
            $0.width.equalTo(menuWidth)
            $0.height.equalTo(menuHeight)
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
    
    private func toggleMenu() {
        let isMenuOpened = menuOverlayView.alpha > 0
        let left: CGFloat = isMenuOpened
            ? view.bounds.width
            : view.bounds.width - menuWidth
        UIView.animate(
            withDuration: 0.24,
            animations: { [weak self] in
                guard let self = self else { return }
                self.menuOverlayView.alpha = isMenuOpened ? 0 : 0.4
                self.menuOverlayView.superview?.layoutIfNeeded()
                self.menuView.snp.updateConstraints {
                    $0.left.equalTo(left)
                }
                self.menuView.superview?.layoutIfNeeded()
            }
        )
    }
    
    @objc func didSwipeRight() {
        toggleMenu()
    }

    @objc func didTapOverlay() {
        toggleMenu()
    }
}

// MARK: HeaderViewDelegate
extension DashboardView: HeaderViewDelegate {
    func menuDidTapped(_ menuItems: [String]) {
        toggleMenu()
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
        topAnimeCardsView.isLoading = true
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
