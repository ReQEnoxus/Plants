//
//  TakePhotoView.swift
//  Plants
//
//  Created by Никита Афанасьев on 11.05.2024.
//

import UIKit
import Lottie

final class TakePhotoView: UIView {
    
    enum State: Equatable {
        case initial
        case loading
        case photoTaken(UIImage)
    }
    
    private enum Constants {
        static let titleFontSize: CGFloat = 32
        static let frameHorizontalInset: CGFloat = 16
        static let frameTopInset: CGFloat = -60
        
        static let targetImageHorizontalInset: CGFloat = 54
        static let buttonTopInset: CGFloat = 12
        static let buttonInteritemInset: CGFloat = 26
        
        static let loadingTitleTopInset: CGFloat = 56
        static let loadingAnimationHorizontalInset: CGFloat = 32
        static let loadingAnimationTopInset: CGFloat = 60
    }
    
    // MARK: - Internal Properties
    
    var state: State = .initial {
        didSet {
            updateState(animated: true)
        }
    }
    
    lazy var takePhotoButton: MainButton = {
        let button = MainButton(type: .system)
        
        return button
    }()
    
    lazy var analyzePhotoButton: MainButton = {
        let button = MainButton(type: .system)
        button.configure(
            with: MainButton.Configuration(
                title: L10n.Scanner.Analyze.title,
                icon: nil,
                tintColor: Assets.Colors.white.color,
                backgroundColor: Assets.Colors.black.color
            )
        )
        
        return button
    }()
    
    // MARK: - Private Properties
    
    private let frameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Assets.Images.frame.image
        
        return imageView
    }()
    
    private let targetPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let loadingAnimationView: LottieAnimationView = {
        let view = LottieAnimationView(animation: Lottie.scanAnimation)
        view.loopMode = .repeat(.greatestFiniteMagnitude)
        
        return view
    }()
    
    private let loadingTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Assets.Colors.black.color
        label.font = FontFamily.Urbanist.bold.font(size: Constants.titleFontSize)
        label.textAlignment = .center
        label.text = L10n.Scanner.Loading.message
        label.numberOfLines = .zero
        
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
    
    // MARK: - Private Methods
    
    private func setupInitialState() {
        addSubviews()
        makeConstraints()
        updateState(animated: false)
        backgroundColor = Assets.Colors.white.color
    }
    
    private func addSubviews() {
        addSubview(loadingTitleLabel)
        addSubview(frameImageView)
        addSubview(targetPhotoImageView)
        addSubview(loadingAnimationView)
        addSubview(takePhotoButton)
        addSubview(analyzePhotoButton)
    }
    
    private func makeConstraints() {
        loadingTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constants.loadingTitleTopInset)
        }
        
        loadingAnimationView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.loadingAnimationHorizontalInset)
            make.top.equalTo(loadingTitleLabel.snp.bottom).offset(Constants.loadingAnimationTopInset)
        }
        
        frameImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.frameHorizontalInset)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constants.frameTopInset)
        }
        
        targetPhotoImageView.snp.makeConstraints { make in
            make.center.equalTo(frameImageView)
            make.leading.trailing.equalToSuperview().inset(Constants.targetImageHorizontalInset)
        }
        
        takePhotoButton.snp.makeConstraints { make in
            make.top.equalTo(frameImageView.snp.bottom).offset(Constants.buttonTopInset)
            make.leading.trailing.equalToSuperview().inset(Constants.targetImageHorizontalInset)
        }
        
        analyzePhotoButton.snp.makeConstraints { make in
            make.top.equalTo(takePhotoButton.snp.bottom).offset(Constants.buttonInteritemInset)
            make.leading.trailing.equalToSuperview().inset(Constants.targetImageHorizontalInset)
        }
    }
    
    private func updateState(animated: Bool) {
        let updateItemsVisibility = {
            switch self.state {
            case .initial:
                self.analyzePhotoButton.alpha = 0
                self.takePhotoButton.alpha = 1
                self.loadingAnimationView.alpha = 0
                self.frameImageView.alpha = 1
                self.targetPhotoImageView.alpha = 1
                self.loadingTitleLabel.alpha = 0
            case .loading:
                self.analyzePhotoButton.alpha = 0
                self.takePhotoButton.alpha = 0
                self.loadingAnimationView.alpha = 1
                self.frameImageView.alpha = 0
                self.targetPhotoImageView.alpha = 0
                self.loadingTitleLabel.alpha = 1
            case .photoTaken:
                self.analyzePhotoButton.alpha = 1
                self.takePhotoButton.alpha = 1
                self.loadingAnimationView.alpha = 0
                self.frameImageView.alpha = 1
                self.targetPhotoImageView.alpha = 1
                self.loadingTitleLabel.alpha = 0
            }
        }
        let completion = {
            if self.state != .loading {
                self.loadingAnimationView.stop()
            }
        }
        
        if animated {
            UIView.animate(withDuration: Durations.single) {
                updateItemsVisibility()
            } completion: { _ in
                completion()
            }
        } else {
            updateItemsVisibility()
            completion()
        }
        switch state {
        case .initial:
            takePhotoButton.configure(
                with: MainButton.Configuration(
                    title: L10n.Scanner.TakePhoto.title,
                    icon: nil,
                    tintColor: Assets.Colors.white.color,
                    backgroundColor: Assets.Colors.black.color
                )
            )
            targetPhotoImageView.image = Assets.Images.camera.image
        case .loading:
            loadingAnimationView.play()
        case .photoTaken(let image):
            takePhotoButton.configure(
                with: MainButton.Configuration(
                    title: L10n.Scanner.RetakePhoto.title,
                    icon: nil,
                    tintColor: Assets.Colors.white.color,
                    backgroundColor: Assets.Colors.black.color
                )
            )
            targetPhotoImageView.image = image
        }
    }
}
