//
//  SignupView.swift
//  Tantei
//
//  Created by Randell on 30/10/22.
//

import FirebaseAuth
import FirebaseDatabase
import SnapKit
import UIKit

class SignupView: UIViewController, UITextFieldDelegate, AuthenticationBaseCoordinated {
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
    
    private lazy var spinner = SpinnerView()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Username"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var signupButton: UIButton = {
        let button = UIButton(
            configuration: .filled(),
            primaryAction: UIAction(
                title: "Signup",
                handler: { _ in
                    self.signupOnTap()
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
    
    var ref: DatabaseReference!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            print("call login view")
        }
        ref = Database.database(url: "https://tantei-c2149-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        configureView()
    }
}

// MARK: UI Setup
private extension SignupView {
    func setupNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func configureView() {
        view.backgroundColor = UIColor.Elements.backgroundLight
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.center.equalToSuperview()
        }
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.top.equalTo(emailTextField.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        view.addSubview(signupButton)
        signupButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: Actions
private extension SignupView {
    func showSpinner() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func hideSpinner() {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
    
    func saveUserInfo(_ user: FirebaseAuth.User, with username: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        changeRequest?.commitChanges { error in
            self.hideSpinner()
            if let error = error {
                print("saveUserInfo: \(error)")
                return
            }
            print("user.uid: \(user.uid)")
            self.ref.child("users").child(user.uid).setValue(["username": username])
        }
    }
    
    func signupOnTap() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let username = usernameTextField.text else {
            return
        }
        showSpinner()
        Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
            self.hideSpinner()
            guard let user = authResult?.user,
                  error == nil else {
                return
            }
            self.saveUserInfo(user, with: username)
            print("call login view")
        })
    }
}

// MARK: RequestDelegate
extension SignupView: RequestDelegate {
    func didUpdate(with state: ViewState) {}
}
