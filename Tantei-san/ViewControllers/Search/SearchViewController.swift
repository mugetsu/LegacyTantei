//
//  SearchViewController.swift
//  Tantei-san
//
//  Created by Randell on 28/9/22.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search by image URL"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.registerCell(cellClass: SearchCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorColor = .clear
        return tableView
    }()

    private let viewModel: SearchViewModel
    
    required init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        navigationItem.largeTitleDisplayMode = .always
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        configureLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: UI Setup
private extension SearchViewController {
    func setupNavigation() {
        navigationItem.titleView = searchBar
    }

    func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
            $0.leading.equalToSuperview()
        }
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: SearchCell.self, indexPath: indexPath)
        cell.configure(viewModel: viewModel.getAnime(for: indexPath))
        return cell
    }
}

// MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ seachBar: UISearchBar) {
        guard let url = seachBar.text else { return }
        viewModel.searchByURL(url: url)
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
                self.tableView.reloadData()
            case .error(let error):
                print(error)
            }
        }
    }
}
