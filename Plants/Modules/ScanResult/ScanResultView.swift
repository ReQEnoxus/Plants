//
//  ScanResultView.swift
//  Plants
//
//  Created by Никита Афанасьев on 11.05.2024.
//

import UIKit
import SnapKit

final class ScanResultView: UIView {
    
    private enum Constants {
        static let resultLabelFontSize: CGFloat = 32
        static let scanDataLabelFontSize: CGFloat = 24
        static let imageHorizontalInset: CGFloat = 44
        
        static let labelHorizontalInset: CGFloat = 24
        static let imageTopInset: CGFloat = 12
        static let scanDataLabelTopInset: CGFloat = 64
        static let scanDataLabelInteritemInset: CGFloat = 4
        
        static let buttonBottomInset: CGFloat = 72
        static let buttonHorizontalInset: CGFloat = 44
        
        static let additionalScrollInset: CGFloat = 8
    }
    
    // MARK: - Internal Properties
    
    var resultImage: UIImage? {
        get {
            return scannedImageView.image
        }
        set {
            scannedImageView.image = newValue
            if let newValue {
                let multiplier = newValue.size.height / newValue.size.width
                imageHeightConstraint?.deactivate()
                scannedImageView.snp.makeConstraints { make in
                    imageHeightConstraint = make.height.equalTo(scannedImageView.snp.width).multipliedBy(multiplier).constraint
                }
            }
        }
    }
    
    let downloadButton: MainButton = {
        let button = MainButton(type: .system)
        button.configure(
            with: MainButton.Configuration(
                title: L10n.Scanner.Result.downloadPhoto,
                icon: MainButton.Configuration.Icon(
                    image: Assets.Icons.arrowDown.image,
                    alignment: .trailing
                ),
                tintColor: Assets.Colors.white.color,
                backgroundColor: Assets.Colors.black.color
            )
        )
        
        return button
    }()
    
    let plantSpeciesLabel: UILabel = {
        let label = UILabel()
        label.textColor = Assets.Colors.darkGray.color
        label.font = FontFamily.Urbanist.bold.font(size: Constants.scanDataLabelFontSize)
        label.numberOfLines = .zero
        
        return label
    }()
    
    let plantDiseaseLabel: UILabel = {
        let label = UILabel()
        label.textColor = Assets.Colors.darkGray.color
        label.font = FontFamily.Urbanist.bold.font(size: Constants.scanDataLabelFontSize)
        label.numberOfLines = .zero
        
        return label
    }()
    
    // MARK: - Private Properties
    
    private let resultTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Assets.Colors.black.color
        label.font = FontFamily.Urbanist.bold.font(size: Constants.resultLabelFontSize)
        label.text = L10n.Scanner.Result.title
        label.textAlignment = .center
        
        return label
    }()
    
    private let scannedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .vertical)
        
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    private var imageHeightConstraint: Constraint?
    
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
        scrollView.contentInset.bottom = bounds.height - downloadButton.frame.minY + Constants.additionalScrollInset
    }
    
    // MARK: - Private Methods
    
    private func setupInitialState() {
        addSubviews()
        makeConstraints()
        backgroundColor = Assets.Colors.white.color
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(resultTitleLabel)
        scrollView.addSubview(scannedImageView)
        scrollView.addSubview(plantSpeciesLabel)
        scrollView.addSubview(plantDiseaseLabel)
        addSubview(downloadButton)
    }
    
    private func makeConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide.snp.edges)
        }
        
        resultTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(Constants.labelHorizontalInset)
            make.top.equalToSuperview()
        }
        
        scannedImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(Constants.imageHorizontalInset)
            make.top.equalTo(resultTitleLabel.snp.bottom).offset(Constants.imageTopInset)
        }
        
        plantSpeciesLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(Constants.labelHorizontalInset)
            make.top.equalTo(scannedImageView.snp.bottom).offset(Constants.scanDataLabelTopInset)
        }
        
        plantDiseaseLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(Constants.labelHorizontalInset)
            make.top.equalTo(plantSpeciesLabel.snp.bottom).offset(Constants.scanDataLabelInteritemInset)
            make.bottom.equalToSuperview()
        }
        
        downloadButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(Constants.buttonHorizontalInset)
            make.bottom.equalTo(self).inset(Constants.buttonBottomInset)
        }
    }
}
