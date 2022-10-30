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
        let button = UIButton(
            configuration: .filled(),
            primaryAction: UIAction(
                title: "Login",
                handler: { _ in
                    self.loginOnTap()
                }
            )
        )
        button.titleLabel?.font = UIFont.Custom.medium?.withSize(16)
        button.configuration?.baseBackgroundColor = UIColor.Illustration.highlight
        button.configuration?.baseForegroundColor = .white
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
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
    func loginOnTap() {
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

