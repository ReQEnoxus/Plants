//
//  AuthMiddleware.swift
//  Plants
//
//  Created by Никита Афанасьев on 11.05.2024.
//

import Foundation
import HTTPTypes
import OpenAPIRuntime

struct AuthMiddleware: ClientMiddleware {
    private enum Constants {
        static let accessTokenKey = "accessToken"
    }
    
    var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: Constants.accessTokenKey)
        }
    }
    
    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        if let accessToken = accessToken {
            request.headerFields.append(
                .init(
                    name: .authorization,
                    value: accessToken
                )
            )
        }
        return try await next(request, body, baseURL)
    }
}
