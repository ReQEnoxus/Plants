//
//  SignupViewController.swift
//  Plants
//
//  Created by Никита Афанасьев on 11.05.2024.
//

import UIKit

final class SignupViewController: UIViewController {
    
    private enum Constants {
        static let minimalFieldLength: Int = 3
    }
    
    private let contentView = SignupView()
    private let authService: AuthService
    private var isFormValid: Bool = false
    
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
    }
    
    private func setupActions() {
        contentView.loginField.delegate = self
        contentView.passwordField.delegate = self
        contentView.passwordConfirmField.delegate = self
        contentView.signupButton.addTarget(self, action: #selector(handleSignupButtonTap), for: .touchUpInside)
        contentView.loginButtonTapped = { [weak contentView] in
            guard contentView?.signupButton.isLoading == false else { return }
            RootManager.shared.setFlow(to: .login, animated: true)
        }
    }
    
    private func validateForm() {
        let email = contentView.loginField.value ?? ""
        
        if !email.isValidEmail {
            isFormValid = false
            contentView.loginField.error = L10n.Auth.Validation.invalidEmail
        } else {
            isFormValid = true
            contentView.loginField.error = nil
        }
    }
    
    private func updateButtonState() {
        let email = contentView.loginField.value ?? ""
        let password = contentView.passwordField.value ?? ""
        let confirmedPassword = contentView.passwordConfirmField.value ?? ""
        
        contentView.signupButton.isEnabled = email.count >= Constants.minimalFieldLength 
        && password.count >= Constants.minimalFieldLength
        && password == confirmedPassword
    }
    
    @objc private func handleSignupButtonTap() {
        validateForm()
        contentView.endEditing(true)
        contentView.networkError = nil
        if isFormValid {
            let email = contentView.loginField.value ?? ""
            let password = contentView.passwordField.value ?? ""
            contentView.signupButton.isLoading = true
            Task {
                do {
                    try await authService.register(
                        data: SignupData(
                            email: email,
                            password: password
                        )
                    )
                    RootManager.shared.setFlow(to: .main, animated: true)
                } catch AuthError.signupError {
                    contentView.signupButton.isLoading = false
                    contentView.networkError = ErrorBlockView.Configuration(
                        title: L10n.Auth.SignupError.title,
                        subtitle: L10n.Auth.SignupError.subtitle
                    )
                }
            }
        }
    }
}

extension SignupViewController: TextInputDelegate {
    func textInputDidChange(_ textInput: TextInputView) {
        updateButtonState()
    }
    
    func textInputShouldReturn(_ textInput: TextInputView) -> Bool {
        switch textInput {
        case contentView.loginField:
            contentView.passwordField.becomeFirstResponder()
        case contentView.passwordField:
            contentView.passwordConfirmField.becomeFirstResponder()
        default:
            textInput.resignFirstResponder()
        }
        return false
    }
}
