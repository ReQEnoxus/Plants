//
//  AuthService.swift
//  Plants
//
//  Created by Никита Афанасьев on 10.05.2024.
//

import Foundation

protocol AuthService {
    var accessToken: String? { get }
    
    func login(data: LoginData) async throws
    func register(data: SignupData) async throws
    func logout()
}
