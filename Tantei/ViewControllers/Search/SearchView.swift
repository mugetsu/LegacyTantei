//
//  SearchView.swift
//  Tantei
//
//  Created by Randell on 28/9/22.
//

import UIKit
import SnapKit

class SearchView: UIViewController, SearchBaseCoordinated {
    private let viewModel: SearchViewModel
    var coordinator: SearchBaseCoordinator?
    
    required init(viewModel: SearchViewModel, coordinator: SearchBaseCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
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
        tableView.registerCell(cellClass: SearchCellView.self)
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
}

// MARK: UI Setup
private extension SearchView {
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
        
        navigationItem.standardAppearance = standardAppearance
        navigationItem.scrollEdgeAppearance = standardAppearance
        navigationItem.titleView = searchController.searchBar
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: UITableViewDataSource
extension SearchView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
}

// MARK: UITableViewDelegate
extension SearchView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: SearchCellView.self, indexPath: indexPath)
        let anime = viewModel.getAnime(with: indexPath.row)
        let searchResult = viewModel.createSearchResultModel(with: anime)
        cell.configure(using: searchResult)
        return cell
    }
}

// MARK: UISearchBarDelegate
extension SearchView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let url = searchBar.text else { return }
        viewModel.searchByImageURL(url: url)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.clearResult()
        coordinator?.moveTo(flow: .dashboard(.initial))
    }
}

// MARK: RequestDelegate
extension SearchView: RequestDelegate {
    func didUpdate(with state: ViewState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch state {
            case .idle:
                break
            case .loading:
                break
            case .success:
                break
            case .error(let error):
                print(error)
            }
            self.navigationItem.title = self.viewModel.getResultTitle()
            self.tableView.reloadData()
        }
    }
}
