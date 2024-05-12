//
//  InputErrorView.swift
//  Plants
//
//  Created by Никита Афанасьев on 09.05.2024.
//

import UIKit

final class InputErrorView: UIView {
    
    struct Configuration {
        let icon: UIImage
        let message: String
    }
    
    private enum Constants {
        static let borderWidth: CGFloat = 1
        static let iconSize = CGSize(width: 20, height: 20)
        static let messageLabelFontSize: CGFloat = 14
        static let contentInsets = UIEdgeInsets(
            top: 6,
            left: 12,
            bottom: 6,
            right: 12
        )
        static let iconTrailingInset: CGFloat = 6
    }
    
    // MARK: - Private Properties
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.Urbanist.bold.font(size: Constants.messageLabelFontSize)
        label.textColor = Assets.Colors.darkGray.color
        
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Assets.Colors.orange.color
        return imageView
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
        messageLabel.text = configuration.message
        iconImageView.image = configuration.icon
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    // MARK: - Private Methods
    
    private func setupInitialState() {
        addSubviews()
        makeConstraints()
        backgroundColor = Assets.Colors.paleOrange.color
        layer.borderColor = Assets.Colors.orange.color.cgColor
        layer.borderWidth = Constants.borderWidth
    }
    
    private func addSubviews() {
        addSubview(iconImageView)
        addSubview(messageLabel)
    }
    
    private func makeConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.contentInsets.left)
            make.size.equalTo(Constants.iconSize)
            make.top.equalToSuperview().inset(Constants.contentInsets.top)
            make.bottom.equalToSuperview().inset(Constants.contentInsets.bottom)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(Constants.iconTrailingInset)
            make.trailing.equalToSuperview().inset(Constants.contentInsets.right)
            make.centerY.equalToSuperview()
        }
    }
}
