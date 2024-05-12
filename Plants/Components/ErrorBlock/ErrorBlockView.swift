//
//  ErrorBlockView.swift
//  Plants
//
//  Created by Никита Афанасьев on 10.05.2024.
//

import UIKit

final class ErrorBlockView: UIView {
    
    struct Configuration {
        let title: String
        let subtitle: String
    }
    
    private enum Constants {
        static let borderWidth: CGFloat = 1
        static let labelFontSize: CGFloat = 16
        static let horizontalInset: CGFloat = 16
        static let verticalInnerSpacing: CGFloat = 4
        static let verticalOuterSpacing: CGFloat = 12
    }
    
    // MARK: - Private Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Assets.Colors.orange.color
        label.font = FontFamily.Urbanist.bold.font(size: Constants.labelFontSize)
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Assets.Colors.orange.color
        label.font = FontFamily.Urbanist.bold.font(size: Constants.labelFontSize)
        
        return label
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    func configure(with configuration: Configuration) {
        titleLabel.text = configuration.title
        subtitleLabel.text = configuration.subtitle
    }
    
    // MARK: - Private Methods
    
    private func setupInitialState() {
        addSubviews()
        makeConstraints()
        layer.borderWidth = Constants.borderWidth
        backgroundColor = Assets.Colors.paleOrange.color
        layer.borderColor = Assets.Colors.orange.color.cgColor
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.verticalOuterSpacing)
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.verticalInnerSpacing)
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
            make.bottom.equalToSuperview().inset(Constants.verticalOuterSpacing)
        }
    }
}
