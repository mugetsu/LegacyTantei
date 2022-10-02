//
//  SearchViewController.swift
//  Tantei-san
//
//  Created by Randell on 28/9/22.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter image URL"
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.registerCell(cellClass: SearchCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.Palette.black
        tableView.separatorColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.estimatedRowHeight = 74
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    private let viewModel: SearchViewModel
    
    required init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        viewModel.searchByURL(url: "")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.frame = CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: 80
        )
    }
}

// MARK: UI Setup
private extension SearchViewController {
    func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
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
