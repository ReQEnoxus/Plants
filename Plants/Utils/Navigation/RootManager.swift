//
//  RootManager.swift
//  Plants
//
//  Created by Никита Афанасьев on 11.05.2024.
//

import UIKit

final class RootManager {
    
    enum Flow {
        case main
        case login
        case signup
    }
    
    static let shared: RootManager = RootManager()
    
    private let authService: AuthService
    
    init(authService: AuthService = UserDefaultsAuthService()) {
        self.authService = authService
    }
    
    func setInitialFlow() {
        if authService.accessToken != nil {
            setFlow(to: .main, animated: false)
        } else {
            setFlow(to: .login, animated: false)
        }
    }
    
    func setFlow(to flow: Flow, animated: Bool) {
        let window = UIApplication.shared.keyWindow
        let controller: UIViewController
        switch flow {
        case .main:
            controller = UINavigationController(rootViewController: TakePhotoViewController())
        case .login:
            controller = LoginViewController()
        case .signup:
            controller = SignupViewController()
        }
        
        window?.rootViewController = controller
        
        if let window, animated {
            UIView.transition(
                with: window,
                duration: Durations.double,
                options: .transitionCrossDissolve,
                animations: {},
                completion: nil
            )
        } else {
            window?.makeKeyAndVisible()
        }
    }
}
