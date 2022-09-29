//
//  SearchViewController.swift
//  Tantei-san
//
//  Created by Randell on 28/9/22.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Search by image URL"
        return label
    }()
    
    private lazy var urlTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: CGFloat(16))
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter image URL"
        textField.addTarget(
            self,
            action: #selector(urlTexFieldEditingChanged),
            for: .editingChanged
        )
        textField.keyboardType = .URL
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.registerCell(cellClass: SearchCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.isHidden = true
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
        navigationItem.titleView = label
    }

    func configureLayout() {
        view.addSubview(urlTextField)
        urlTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
                .inset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
                .inset(UIEdgeInsets(top: 52, left: 16, bottom: 16, right: 16))
        }
    }
}

// MARK: Actions
private extension SearchViewController {
    @objc private func urlTexFieldEditingChanged(_ textField: UITextField) {
        guard let url = textField.text else { return }
        view.endEditing(true)
        viewModel.searchByURL(url: url)
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
                let hasAnime = self.viewModel.numberOfItems > 0
                self.urlTextField.isHidden = hasAnime
                self.tableView.isHidden = !hasAnime
                self.tableView.setContentOffset(.zero, animated: true)
                self.tableView.reloadData()
            case .error(let error):
                print(error)
            }
        }
    }
}
