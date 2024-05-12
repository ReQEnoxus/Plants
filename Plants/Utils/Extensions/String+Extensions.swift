//
//  String+Extensions.swift
//  Plants
//
//  Created by Никита Афанасьев on 11.05.2024.
//

import Foundation

extension String {
    
    var isValidEmail: Bool {
        guard let regex = try? NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}") else { return false }
        return regex.firstMatch(in: self, range: NSRange(location: .zero, length: count)) != nil
    }
}
