//
//  UserDefaultsAuthService.swift
//  Plants
//
//  Created by Никита Афанасьев on 10.05.2024.
//

import Foundation
import OpenAPIRuntime

final class UserDefaultsAuthService: AuthService {
    private enum Constants {
        static let accessTokenKey = "accessToken"
    }
    
    var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: Constants.accessTokenKey)
        }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: Constants.accessTokenKey)
            } else {
                UserDefaults.standard.setValue(newValue, forKey: Constants.accessTokenKey)
            }
        }
    }
    
    private let client: Client
    
    init(client: Client = .main) {
        self.client = client
    }
    
    func login(data: LoginData) async throws {
        do {
            let response = try await client.login_for_access_token_user_login_post(
                .init(
                    body: .json(
                        .init(
                            username: .init(stringLiteral: data.email),
                            password: .init(stringLiteral: data.password)
                        )
                    )
                )
            )
            let token = try response.ok.body.json.access_token.value as? String
            if let token {
                accessToken = token
            } else {
                throw AuthError.loginError
            }
        } catch {
            throw AuthError.loginError
        }
    }
    
    func register(data: SignupData) async throws {
        do {
            let response = try await client.register_for_access_token_user_register_post(
                .init(
                    body: .json(
                        .init(
                            username: .init(stringLiteral: data.email),
                            password: .init(stringLiteral: data.password)
                        )
                    )
                )
            )
            let token = try response.ok.body.json.access_token.value as? String
            if let token {
                accessToken = token
            } else {
                throw AuthError.loginError
            }
        } catch {
            throw AuthError.loginError
        }
    }
    
    func logout() {
        accessToken = nil
    }
}
