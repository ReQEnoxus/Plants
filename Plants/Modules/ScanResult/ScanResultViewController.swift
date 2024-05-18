//
//  ScanResultViewController.swift
//  Plants
//
//  Created by Никита Афанасьев on 11.05.2024.
//

import UIKit

final class ScanResultViewController: UIViewController {
    
    private let scanResult: ScanResult
    private let contentView = ScanResultView()
    
    init(scanResult: ScanResult) {
        self.scanResult = scanResult
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
        setupContentView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        let buttonAppearance = UIBarButtonItemAppearance(style: .plain)
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: Assets.Colors.black.color]
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .clear
        appearance.setBackIndicatorImage(Assets.Icons.arrowLeft.image, transitionMaskImage: Assets.Icons.arrowLeft.image)
        appearance.buttonAppearance = buttonAppearance
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = Assets.Colors.black.color
    }
    
    private func setupContentView() {
        contentView.resultImage = UIImage(data: scanResult.photo)?.withText(text: scanResult.plantDisease)
        contentView.plantSpeciesLabel.text = L10n.Scanner.Result.plantSpecies(scanResult.plantSpecies)
        contentView.plantDiseaseLabel.text = L10n.Scanner.Result.plantDisease(scanResult.plantDisease)
    }
    
    private func setupActions() {
        contentView.downloadButton.addTarget(self, action: #selector(downloadPhoto), for: .touchUpInside)
    }
    
    @objc private func downloadPhoto() {
        guard let image = contentView.resultImage else { return }
        contentView.downloadButton.isLoading = true
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        contentView.downloadButton.isLoading = false
    }
}
