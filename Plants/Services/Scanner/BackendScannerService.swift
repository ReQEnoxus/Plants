//
//  BackendScannerService.swift
//  Plants
//
//  Created by Никита Афанасьев on 11.05.2024.
//

import Foundation
import OpenAPIRuntime

final class BackendScannerService: ScannerService {
    
    private let client: Client
    private let authService: AuthService
    
    init(client: Client = .main, authService: AuthService = UserDefaultsAuthService()) {
        self.client = client
        self.authService = authService
    }
    
    func performScan(data: ScanData) async throws -> ScanResult {
        do {
            let response = try await client.analyze_analyze__post(
                .init(
                    body: .multipartForm(
                        .init(
                            [
                                .undocumented(
                                    .init(
                                        name: "file",
                                        filename: "input.jpg",
                                        headerFields: [.contentType: "image/jpeg"],
                                        body: HTTPBody(data.photo)
                                    )
                                )
                            ]
                        )
                    )
                )
            )
            switch response {
            case .ok(let ok):
                let result = try ok.body.json
                if let species = result.plant_type.value as? String,
                   let disease = result.decease_type.value as? String {
                    return ScanResult(
                        photo: data.photo,
                        plantSpecies: species,
                        plantDisease: disease
                    )
                } else {
                    throw ScanError.unknown
                }
            case .undocumented(let statusCode, _):
                if statusCode == 401 {
                    throw ScanError.unauthorized
                } else {
                    throw ScanError.unknown
                }
            default:
                throw ScanError.unknown
            }
        } catch {
            throw ScanError.unknown
        }
    }
}
