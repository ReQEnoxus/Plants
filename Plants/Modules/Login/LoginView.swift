//
//  LoginView.swift
//  Plants
//
//  Created by Никита Афанасьев on 09.05.2024.
//

import UIKit

final class LoginView: UIView {
    
    private enum Constants {
        static let fieldSpacing: CGFloat = 24
        static let loginBlockHorizontalInset: CGFloat = 44
        static let loginBlockTopInsetMultiplier: CGFloat = 206 / 932
        static let backgroundImageTopInsetMultiplier: CGFloat = 115 / 932
        static let bottomPromptVerticalInset: CGFloat = 80
        static let bottomPromptHorizontalInset: CGFloat = 24
        static let loginBlockHorizontalSpacing: CGFloat = 44
        static let promptFontSize: CGFloat = 14
        static let additionalKeyboardDelta: CGFloat = 24
        static let errorBlockTopInset: CGFloat = 38
    }
    
    // MARK: - Internal Properties
    
    let loginField: TextInputView = {
        let field = TextInputView()
        field.configure(
            with: TextInputView.Configuration(
                title: L10n.Auth.Email.title,
                placeholder: L10n.Auth.Email.placeholder,
                leadingIcon: Assets.Icons.email.image,
                isSecure: false,
                keyboardType: .emailAddress,
                returnKeyType: .next
            )
        )
        
        return field
    }()
    
    let passwordField = {
        let field = TextInputView()
        field.configure(
            with: TextInputView.Configuration(
                title: L10n.Auth.Password.title,
                placeholder: L10n.Auth.Password.placeholder,
                leadingIcon: Assets.Icons.lock.image,
                isSecure: true,
                keyboardType: .default,
                returnKeyType: .done
            )
        )
        
        return field
    }()
    
    let loginButton: MainButton = {
        let button = MainButton()
        button.configure(
            with: MainButton.Configuration(
                title: L10n.Auth.LoginButton.title,
                icon: MainButton.Configuration.Icon(
                    image: Assets.Icons.arrowRight.image,
                    alignment: .trailing
                ),
                tintColor: Assets.Colors.white.color,
                backgroundColor: Assets.Colors.black.color
            )
        )
        button.isEnabled = false
        
        return button
    }()
    
    var registerButtonTapped: VoidClosure?
    var networkError: ErrorBlockView.Configuration? {
        didSet {
            updateNetworkError()
        }
    }
    
    // MARK: - Private Properties
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Assets.Images.leaves.image
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        
        return imageView
    }()
    
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    private let networkErrorView: ErrorBlockView = {
        let errorView = ErrorBlockView()
        errorView.isHidden = true
        
        return errorView
    }()
    
    private let loginBlockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.fieldSpacing
        
        return stackView
    }()
    
    
    private let backgroundImageTopLayoutGuide = UILayoutGuide()
    
    private lazy var registerPromptLabel: MarkupTextView = {
        let textView = MarkupTextView()
        textView.font = FontFamily.Urbanist.bold.font(size: Constants.promptFontSize)
        textView.textColor = Assets.Colors.darkGray.color
        
        let string = L10n.Auth.GoToRegister.prompt
        let lastWordCount = string.split(separator: " ").last?.count ?? .zero
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(
            .linkAction,
            value: LinkAction { [weak self] in
                self?.registerButtonTapped?()
            },
            range: NSRange(
                location: string.count - lastWordCount,
                length: lastWordCount
            )
        )
        textView.setAttributedText(attributedString)
        textView.textAlignment = .center
        
        return textView
    }()
    
    private var loginBlockTopOffset: CGFloat = .zero
    private var currentDelta: CGFloat = .zero
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialState()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInitialState()
    }
    
    // MARK: - Internal Properties
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loginBlockTopOffset = bounds.height * Constants.loginBlockTopInsetMultiplier
        mainScrollView.contentInset.top = loginBlockTopOffset
    }
    
    // MARK: - Private Methods
    
    private func setupInitialState() {
        addSubviews()
        makeConstraints()
        setupKeyboardNotifications()
        setupKeyboardDismissGesture()
        backgroundColor = Assets.Colors.white.color
    }
    
    private func addSubviews() {
        addSubview(backgroundImageView)
        addSubview(mainScrollView)
        mainScrollView.addSubview(loginBlockStackView)
        loginBlockStackView.addArrangedSubview(loginField)
        loginBlockStackView.addArrangedSubview(passwordField)
        loginBlockStackView.addArrangedSubview(loginButton)
        mainScrollView.addSubview(networkErrorView)
        addSubview(registerPromptLabel)
        addLayoutGuide(backgroundImageTopLayoutGuide)
    }
    
    private func makeConstraints() {
        mainScrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        loginField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(loginBlockStackView)
        }
        
        passwordField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(loginBlockStackView)
        }
        
        loginButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(loginBlockStackView)
        }
        
        loginBlockStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(Constants.loginBlockHorizontalSpacing)
        }
        
        networkErrorView.snp.makeConstraints { make in
            make.top.equalTo(loginBlockStackView.snp.bottom).offset(Constants.errorBlockTopInset)
            make.leading.trailing.equalTo(self).inset(Constants.loginBlockHorizontalInset)
        }
        
        backgroundImageTopLayoutGuide.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(snp.height).multipliedBy(Constants.backgroundImageTopInsetMultiplier)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(backgroundImageTopLayoutGuide.snp.bottom)
        }
        
        registerPromptLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.bottomPromptHorizontalInset)
            make.bottom.equalToSuperview().inset(Constants.bottomPromptVerticalInset)
        }
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillOpen),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillClose),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setupKeyboardDismissGesture() {
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleOutsideTap)
        )
        addGestureRecognizer(recognizer)
    }
    
    private func updateNetworkError() {
        if let networkError {
            networkErrorView.configure(with: networkError)
            networkErrorView.isHidden = false
        } else {
            networkErrorView.isHidden = true
        }
    }
    
    @objc private func keyboardWillOpen(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize: CGSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        else { return }
        let loginBlockLowestPoint = loginBlockTopOffset + loginBlockStackView.bounds.height + safeAreaInsets.top
        if loginBlockLowestPoint + keyboardSize.height > bounds.height {
            let delta = loginBlockLowestPoint + keyboardSize.height - bounds.height + Constants.additionalKeyboardDelta
            currentDelta = delta
            
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            UIView.animate(withDuration: duration) {
                self.mainScrollView.contentInset.top = self.loginBlockTopOffset - delta
            }
        }
    }
    
    @objc private func keyboardWillClose(notification: NSNotification) {
        let duration: TimeInterval = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        currentDelta = .zero
        UIView.animate(withDuration: duration) {
            self.mainScrollView.contentInset.top = self.loginBlockTopOffset
        }
    }
    
    @objc private func handleOutsideTap() {
        endEditing(true)
    }
}
