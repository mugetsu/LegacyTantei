//
//  SearchViewController.swift
//  Tantei-san
//
//  Created by Randell on 28/9/22.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController, SearchBaseCoordinated {
    
    var coordinator: SearchBaseCoordinator?
    
    private let viewModel: SearchViewModel
    
    required init(viewModel: SearchViewModel, coordinator: SearchBaseCoordinator) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        self.coordinator = coordinator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.placeholder = "Enter image URL"
        searchController.searchBar.searchTextField.textColor = UIColor.Elements.headline
        searchController.searchBar.searchTextField.leftView = nil
        return searchController
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.registerCell(cellClass: SearchCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.Elements.backgroundLight
        tableView.separatorColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        configureLayout()
        searchController.isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: UI Setup
private extension SearchViewController {
    func setupNavigation() {
        let standardAppearance = UINavigationBarAppearance()
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.Elements.headline,
            NSAttributedString.Key.font: UIFont.Custom.bold!.withSize(32)
        ]
        standardAppearance.backgroundColor = UIColor.Elements.backgroundLight
        standardAppearance.shadowColor = .clear
        standardAppearance.shadowImage = UIImage()
        standardAppearance.largeTitleTextAttributes = textAttributes
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.Illustration.highlight,
            .font: UIFont.Custom.regular ?? UIFont()
        ]
        UIBarButtonItem.appearance(
            whenContainedInInstancesOf: [UISearchBar.self]
        ).setTitleTextAttributes(attributes, for: .normal)
        
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.standardAppearance = standardAppearance
        navigationItem.scrollEdgeAppearance = standardAppearance
        navigationItem.titleView = searchController.searchBar
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    
    func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: SearchCell.self, indexPath: indexPath)
        cell.configure(viewModel: viewModel.getAnime(for: indexPath))
        return cell
    }
}

// MARK: UISearchBarDelegate
extension SearchViewController: UISearchControllerDelegate, UISearchBarDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let url = searchBar.text else { return }
        viewModel.searchByURL(url: url)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        coordinator?.moveTo(flow: .dashboard(.initial))
    }
}

// MARK: RequestDelegate
extension SearchViewController: RequestDelegate {
    func didUpdate(with state: ViewState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch state {
            case .idle:
                break
            case .loading:
                break
            case .success:
                self.navigationItem.title = "Check out these!"
                self.tableView.reloadData()
            case .error(let error):
                print(error)
            }
        }
    }
}
