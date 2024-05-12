//
//  LoginViewController.swift
//  Plants
//
//  Created by Никита Афанасьев on 09.05.2024.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    private enum Constants {
        static let minimalFieldLength: Int = 3
        static let minimalPasswordLength: Int = 8
    }
    
    private let contentView = LoginView()
    private let authService: AuthService
    
    init(authService: AuthService = UserDefaultsAuthService()) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        updateState()
    }
    
    private func setupActions() {
        contentView.loginField.delegate = self
        contentView.passwordField.delegate = self
        contentView.loginButton.addTarget(self, action: #selector(handleLoginButtonTap), for: .touchUpInside)
        contentView.registerButtonTapped = { [weak contentView] in
            guard contentView?.loginButton.isLoading == false else { return }
            RootManager.shared.setFlow(to: .signup, animated: true)
        }
    }
    
    private func updateState() {
        let email = contentView.loginField.value ?? ""
        let password = contentView.passwordField.value ?? ""
        contentView.loginButton.isEnabled = email.count >= Constants.minimalFieldLength && password.count >= Constants.minimalPasswordLength
    }
    
    @objc private func handleLoginButtonTap() {
        contentView.endEditing(true)
        contentView.loginButton.isLoading = true
        contentView.networkError = nil
        let email = contentView.loginField.value ?? ""
        let password = contentView.passwordField.value ?? ""
        Task {
            do {
                try await authService.login(
                    data: LoginData(
                        email: email,
                        password: password
                    )
                )
                RootManager.shared.setFlow(to: .main, animated: true)
            } catch AuthError.loginError {
                contentView.networkError = ErrorBlockView.Configuration(
                    title: L10n.Auth.LoginError.title,
                    subtitle: L10n.Auth.LoginError.subtitle
                )
                contentView.loginButton.isLoading = false
            }
        }
    }
}

extension LoginViewController: TextInputDelegate {
    
    func textInputDidChange(_ textInput: TextInputView) {
        updateState()
    }
    
    func textInputShouldReturn(_ textInput: TextInputView) -> Bool {
        switch textInput {
        case contentView.loginField:
            contentView.passwordField.becomeFirstResponder()
        default:
            textInput.resignFirstResponder()
        }
        return false
    }
}

