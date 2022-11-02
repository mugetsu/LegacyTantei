//
//  DashboardView.swift
//  Tantei
//
//  Created by Randell on 1/10/22.
//

import UIKit
import SnapKit

class DashboardView: UIViewController, DashboardBaseCoordinated {
    private let viewModel: DashboardViewModel
    var coordinator: DashboardBaseCoordinator?
    
    required init(viewModel: DashboardViewModel, coordinator: DashboardBaseCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        let titles = viewModel.categoryTitles
        let view = CategoryCardsView(titles: titles + titles)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var topAnimeCardsView: AnimeCardsView = {
        let view = AnimeCardsView(cardType: .airing, animes: [])
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cardHeight: Int = 337
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        configureView()
        viewModel.fetchData()
    }
}

// MARK: UI Setup
private extension DashboardView {
    func setupNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func configureView() {
        view.backgroundColor = UIColor.Elements.backgroundDark
        configureHeaderView()
        configureTopAnimeView()
    }
    
    func configureHeaderView() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.equalTo(view)
            $0.leading.trailing.equalTo(view).inset(16)
        }
    }
    
    func configureTopAnimeView() {
        view.addSubview(topAnimeView)
        topAnimeView.snp.makeConstraints {
            $0.height.equalTo(cardHeight)
            $0.top.equalTo(headerView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        topAnimeView.addSubview(topAnimeTitleLabel)
        topAnimeTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(topAnimeView).inset(16)
        }
        topAnimeView.addSubview(categoryView)
        categoryView.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.top.equalTo(topAnimeTitleLabel.snp.bottom)
            $0.leading.equalTo(topAnimeView).offset(16)
            $0.trailing.equalTo(topAnimeView)
        }
        topAnimeView.addSubview(topAnimeCardsView)
        topAnimeCardsView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.top.equalTo(categoryView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: Actions
extension DashboardView {
    private func presentModal(with anime: Anime) {
        let detailView = DetailView(anime: anime)
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
        switch text {
        case TopAnimeType.upcoming.description:
            break
        case TopAnimeType.popular.description:
            break
        case TopAnimeType.favorite.description:
            break
        default:
            let topAiringModel = self.viewModel.getTopAiringAnimes()
            self.topAnimeCardsView.cardsUpdate(with: topAiringModel)
        }
    }
}

// MARK: AnimeCardsViewDelegate
extension DashboardView: AnimeCardsViewDelegate {
    func didSelectItem(at index: Int, from type: TopAnimeType) {
        var animes: [Jikan.AnimeDetails] = []
        switch type {
        case .airing:
            animes = viewModel.getTopAiringAnimes()
        default:
            break
        }
        let anime = Common.createAnimeModel(with: animes[index])
        presentModal(with: anime)
    }
}

// MARK: RequestDelegate
extension DashboardView: RequestDelegate {
    func didUpdate(with state: ViewState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch state {
            case .idle:
                break
            case .loading:
                break
            case .success:
                let topAiringModel = self.viewModel.getTopAiringAnimes()
                self.topAnimeCardsView.cardsUpdate(with: topAiringModel)
            case .error(let error):
                print(error)
            }
        }
    }
}
