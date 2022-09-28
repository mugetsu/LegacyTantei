//
//  SearchViewController.swift
//  Tantei-san
//
//  Created by Randell on 28/9/22.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        let searchCell = UINib(nibName: "SearchCell", bundle: nil)
        tableView.register(searchCell, forCellReuseIdentifier: "SearchCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
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
        viewModel.searchByURL(url: "https://i0.wp.com/www.animegeek.com/wp-content/uploads/2022/09/Sherry2.jpg")
    }
}

// MARK: UI Setup
private extension SearchViewController {
    func setupNavigation() {
//        navigationItem.titleView = 
    }

    func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchCell {
            cell.configure(viewModel: viewModel.getAnime(for: indexPath))
            return cell
        }
        return UITableViewCell()
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
                self.tableView.setContentOffset(.zero, animated: true)
                self.tableView.reloadData()
                break
            case .error(let error):
                break
            }
        }
    }
}
