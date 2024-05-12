//
//  TakePhotoViewController.swift
//  Plants
//
//  Created by Никита Афанасьев on 11.05.2024.
//

import UIKit
import AVFoundation

final class TakePhotoViewController: UIViewController {
    
    private let contentView = TakePhotoView()
    private let scanerService: ScannerService
    
    init(scanerService: ScannerService = BackendScannerService()) {
        self.scanerService = scanerService
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
        setupNavigationBar()
        title = " "
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        contentView.state = .initial
    }
    
    private func setupActions() {
        contentView.takePhotoButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        contentView.analyzePhotoButton.addTarget(self, action: #selector(analyze), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .clear
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    private func checkCameraPermissions(success: @escaping VoidClosure, failure: @escaping VoidClosure) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            DispatchQueue.main.async {
                failure()
            }
        case .authorized:
            DispatchQueue.main.async {
                success()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { permissionIsGranted in
                DispatchQueue.main.async {
                    if permissionIsGranted {
                        success()
                    }
                }
            }
        default:
            break
        }
    }
    
    @objc private func takePhoto() {
        checkCameraPermissions { [weak self] in
            self?.presentPhotoPicker()
        } failure: { [weak self] in
            self?.presentPermissionsAlert()
        }
    }
    
    private func presentPhotoPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func presentPermissionsAlert() {
        let alertController = UIAlertController(
            title: L10n.Scanner.CameraAccess.title,
            message: L10n.Scanner.CameraAccess.description,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: L10n.Scanner.CameraAccess.cancel, style: .cancel))
        alertController.addAction(UIAlertAction(title: L10n.Scanner.CameraAccess.settings, style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
    }
    
    @objc private func analyze() {
        guard case .photoTaken(let image) = contentView.state,
              let data = image.jpegData(compressionQuality: 1) else { return }
        contentView.state = .loading
        Task {
            do {
                let scanResult = try await scanerService.performScan(data: ScanData(photo: data))
                let controller = ScanResultViewController(scanResult: scanResult)
                navigationController?.pushViewController(controller, animated: true)
            } catch ScanError.unknown {
                contentView.state = .photoTaken(image)
            } catch ScanError.unauthorized {
                RootManager.shared.setFlow(to: .login, animated: true)
            }
        }
    }
}

extension TakePhotoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        contentView.state = .photoTaken(image)
        picker.dismiss(animated: true)
    }
}
