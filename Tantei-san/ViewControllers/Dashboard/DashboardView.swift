//
//  DashboardView.swift
//  Tantei-san
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
    
    internal lazy var topAnimeView: SwipeableCardsView = {
        let swipeableCardsView = SwipeableCardsView()
        let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        swipeableCardsView.cardSpacing = 16
        swipeableCardsView.insets = insets
        return swipeableCardsView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Custom.thin?.withSize(21)
        label.textColor = .white
        label.text = "'Sup"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
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
        navigationItem.title = "Hello"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureView() {
        view.backgroundColor = UIColor.Elements.backgroundLight
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
