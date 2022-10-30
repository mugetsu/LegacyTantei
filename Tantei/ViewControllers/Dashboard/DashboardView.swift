//
//  DashboardView.swift
//  Tantei
//
//  Created by Randell on 1/10/22.
//

import UIKit
import SnapKit

class DashboardView: UIViewController, DashboardBaseCoordinated {
    internal let viewModel: DashboardViewModel
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
    
    internal lazy var headerView: HeaderView = {
        let view = HeaderView(model: .init(
            title: viewModel.getGreeting()
        ))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    internal lazy var topAnimeView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    internal lazy var topAnimeTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.font = UIFont.Custom.regular?.withSize(17)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Top Anime"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal lazy var topAnimeCategoryLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.font = UIFont.Custom.bold?.withSize(34)
        label.textColor = UIColor.Illustration.highlight
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Airing"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal lazy var skeletonCardsView: SwipeableCardsView = {
        let swipeableCardsView = SwipeableCardsView()
        let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        swipeableCardsView.cardSpacing = 16
        swipeableCardsView.insets = insets
        swipeableCardsView.cardWidthFactor = 0.5
        swipeableCardsView.alpha = 1.0
        swipeableCardsView.isUserInteractionEnabled = false
        return swipeableCardsView
    }()
    
    internal lazy var topAnimeCardsView: SwipeableCardsView = {
        let swipeableCardsView = SwipeableCardsView()
        let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        swipeableCardsView.cardSpacing = 16
        swipeableCardsView.insets = insets
        swipeableCardsView.cardWidthFactor = 0.5
        swipeableCardsView.alpha = 0.0
        return swipeableCardsView
    }()
    
    internal let cardHeight: Int = 337
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        configureView()
        viewModel.getTopAnimes(type: .tv, filter: .airing)
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(34)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    func configureTopAnimeView() {
        view.addSubview(topAnimeView)
        topAnimeView.snp.makeConstraints {
            $0.height.equalTo(cardHeight)
            $0.top.equalTo(headerView.snp.bottom).offset(26)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        topAnimeView.addSubview(topAnimeTitleLabel)
        topAnimeTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(topAnimeView).inset(16)
        }
        topAnimeView.addSubview(topAnimeCategoryLabel)
        topAnimeCategoryLabel.snp.makeConstraints {
            $0.top.equalTo(topAnimeTitleLabel.snp.bottom)
            $0.leading.trailing.equalTo(topAnimeView).inset(16)
        }
        skeletonCardsView.dataSource = self
        skeletonCardsView.delegate = self
        topAnimeView.addSubview(skeletonCardsView)
        skeletonCardsView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.top.equalTo(topAnimeCategoryLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
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
                self.updateTopAnimeView()
            case .error(let error):
                print(error)
            }
        }
    }
}
