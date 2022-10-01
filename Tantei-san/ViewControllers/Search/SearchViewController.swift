//
//  SearchViewController.swift
//  Tantei-san
//
//  Created by Randell on 28/9/22.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = UIColor.Palette.purple
        return stackView
    }()
    
    private lazy var paddingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.Palette.purple
        return view
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search by image URL"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .white
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
        searchBar.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: UI Setup
private extension SearchViewController {
    func setupNavigation() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.backgroundColor = UIColor.Palette.purple
        standardAppearance.shadowColor = .clear
        standardAppearance.shadowImage = UIImage()
        titleStackView.addArrangedSubview(searchBar)
        navigationItem.titleView = titleStackView
        navigationItem.standardAppearance = standardAppearance
        navigationItem.compactAppearance = standardAppearance
        navigationItem.scrollEdgeAppearance = standardAppearance
    }

    func configureLayout() {
        view.addSubview(paddingView)
        paddingView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(94)
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(16)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(paddingView.snp.bottom)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-32)
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
        self.viewModel.searchByURL(url: url)
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
