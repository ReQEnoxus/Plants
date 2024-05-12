//
//  ScannerService.swift
//  Plants
//
//  Created by Никита Афанасьев on 11.05.2024.
//

import Foundation

protocol ScannerService {
    func performScan(data: ScanData) async throws -> ScanResult
}
