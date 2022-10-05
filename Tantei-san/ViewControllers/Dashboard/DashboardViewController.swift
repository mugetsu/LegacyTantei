//
//  DashboardViewController.swift
//  Tantei-san
//
//  Created by Randell on 1/10/22.
//

import UIKit
import SnapKit

class DashboardViewController: UIViewController, DashboardBaseCoordinated {
    
    var coordinator: DashboardBaseCoordinator?
    
    private let viewModel: DashboardViewModel
    
    required init(viewModel: DashboardViewModel, coordinator: DashboardBaseCoordinator) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        self.coordinator = coordinator
        navigationItem.largeTitleDisplayMode = .always
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        configureView()
        configureLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: UI Setup
private extension DashboardViewController {
    func configureView() {
        view.backgroundColor = UIColor.Elements.backgroundLight
    }
    
    func configureLayout() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}


// MARK: RequestDelegate
extension DashboardViewController: RequestDelegate {
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
        }
    }
}
