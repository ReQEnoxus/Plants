//
//  TextInputView.swift
//  Plants
//
//  Created by Никита Афанасьев on 09.05.2024.
//

import UIKit

final class TextInputView: UIView {
    
    struct Configuration {
        let title: String
        let placeholder: String
        let leadingIcon: UIImage?
        let isSecure: Bool
        let keyboardType: UIKeyboardType
        let returnKeyType: UIReturnKeyType
    }
    
    private enum Constants {
        static let cornerRadius: CGFloat = 28
        static let titleFontSize: CGFloat = 14
        static let stackViewSpacing: CGFloat = 8
        static let textFieldFontSize: CGFloat = 16
        static let buttonSize: CGSize = CGSize(width: 24, height: 24)
    }
    
    // MARK: - Internal Properties
    
    var value: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    var error: String? {
        didSet {
            updateErrorState()
        }
    }
    weak var delegate: TextInputDelegate?
    
    // MARK: - Private Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Assets.Colors.black.color
        label.font = FontFamily.Urbanist.extraBold.font(size: Constants.titleFontSize)
        
        return label
    }()
    
    private lazy var textField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.borderStyle = .none
        textField.font = FontFamily.Urbanist.bold.font(size: Constants.textFieldFontSize)
        textField.textColor = Assets.Colors.darkGray.color
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.addTarget(self, action: #selector(handleValueChanged), for: .editingChanged)
        textField.backgroundColor = Assets.Colors.white.color
        
        return textField
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        stackView.distribution = .fill
        stackView.alignment = .leading
        
        return stackView
    }()
    
    private lazy var secureToggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Assets.Icons.eye.image, for: .normal)
        button.addTarget(self, action: #selector(handleSecureModeToggle), for: .touchUpInside)
        button.tintColor = Assets.Colors.gray.color
        
        return button
    }()
    
    private let leadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Assets.Colors.black.color
        
        return imageView
    }()
    
    private let errorView: InputErrorView = {
        let view = InputErrorView()
        view.isHidden = true
        
        return view
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialState()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInitialState()
    }
    
    // MARK: - Internal Methods
    
    func configure(with configuration: Configuration) {
        titleLabel.text = configuration.title
        textField.attributedPlaceholder = NSAttributedString(
            string: configuration.placeholder,
            attributes: [
                .foregroundColor: Assets.Colors.darkGray.color,
                .font: FontFamily.Urbanist.bold.font(size: Constants.textFieldFontSize)
            ]
        )
        if let leadingIcon = configuration.leadingIcon {
            leadingImageView.image = leadingIcon
            textField.leftView = leadingImageView
        } else {
            textField.leftView = nil
        }
        textField.leftViewMode = configuration.leadingIcon == nil ? .never : .always
        
        textField.isSecureTextEntry = configuration.isSecure
        textField.rightView = configuration.isSecure ? secureToggleButton : nil
        textField.rightViewMode = configuration.isSecure ? .always : .never
        
        textField.isSecureTextEntry = configuration.isSecure
        textField.keyboardType = configuration.keyboardType
        textField.returnKeyType = configuration.returnKeyType
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    
    // MARK: - Private Methods
    
    private func setupInitialState() {
        addSubviews()
        makeConstraints()
        textField.delegate = self
    }
    
    private func addSubviews() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(textField)
        containerStackView.addArrangedSubview(errorView)
    }
    
    private func makeConstraints() {
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        
        errorView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        
        leadingImageView.snp.makeConstraints { make in
            make.size.equalTo(Constants.buttonSize).priority(.high)
        }
        
        secureToggleButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.buttonSize).priority(.high)
        }
    }
    
    private func updateActiveStateShadow(visible: Bool) {
        textField.layer.applySketchShadow(
            properties: CALayer.SketchShadow(
                color: Assets.Colors.green.color,
                alpha: 0.25,
                x: 0,
                y: 0,
                blur: 1,
                spread: visible ? 4 : 0,
                cornerRadius: Constants.cornerRadius
            )
        )
    }
    
    private func updateBorder(visible: Bool) {
        textField.layer.borderWidth = visible ? 1 : 0
        textField.layer.borderColor = error == nil ? Assets.Colors.green.color.cgColor : Assets.Colors.orange.color.cgColor
    }
    
    private func updateErrorState() {
        UIView.animate(withDuration: Durations.single) {
            if let error = self.error, !error.isEmpty {
                self.errorView.configure(
                    with: InputErrorView.Configuration(
                        icon: Assets.Icons.warning.image,
                        message: error
                    )
                )
                if self.errorView.isHidden {
                    self.errorView.alpha = 1
                    self.errorView.isHidden = false
                }
            } else {
                if !self.errorView.isHidden {
                    self.errorView.alpha = .zero
                    self.errorView.isHidden = true
                }
            }
        }
        if error != nil {
            updateBorder(visible: true)
        }
    }
    
    @objc private func handleSecureModeToggle() {
        textField.isSecureTextEntry.toggle()
    }
    
    @objc private func handleValueChanged() {
        delegate?.textInputDidChange(self)
    }
}

extension TextInputView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateActiveStateShadow(visible: true)
        updateBorder(visible: true)
        delegate?.textInputDidBeginEditing(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateActiveStateShadow(visible: false)
        if error == nil {
            updateBorder(visible: false)
        }
        delegate?.textInputDidEndEditing(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textInputShouldReturn(self) ?? true
    }
}
