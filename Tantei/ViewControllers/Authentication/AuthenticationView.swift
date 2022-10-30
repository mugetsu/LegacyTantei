//
//  AuthenticationView.swift
//  Tantei
//
//  Created by Randell on 8/10/22.
//

import UIKit
import SnapKit

class AuthenticationView: UIViewController, AuthenticationBaseCoordinated {
    private let viewModel: AuthenticationViewModel
    var coordinator: AuthenticationBaseCoordinator?
    
    required init(viewModel: AuthenticationViewModel, coordinator: AuthenticationBaseCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.Custom.medium?.withSize(16)
        button.backgroundColor = UIColor.Illustration.highlight
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        button.addTarget(
            self,
            action: #selector(loginOnTap),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        configureView()
    }
}

// MARK: UI Setup
private extension AuthenticationView {
    func setupNavigation() {
        navigationItem.title = "Welcome"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureView() {
        view.backgroundColor = UIColor.Elements.backgroundLight
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: Actions
private extension AuthenticationView {
    @objc func loginOnTap() {
        transitionToNewRootViewController(with: MainCoordinator().start())
    }
}

// MARK: RequestDelegate
extension AuthenticationView: RequestDelegate {
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

