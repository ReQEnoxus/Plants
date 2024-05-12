//
//  PaddedTextField.swift
//  Plants
//
//  Created by Никита Афанасьев on 09.05.2024.
//

import UIKit

final class PaddedTextField: UITextField {
    
    private enum Constants {
        static let paddedTextFieldInsets = UIEdgeInsets(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16
        )
        
        static let textHorizontalInset: CGFloat = 8
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let leftViewRect = leftViewRect(forBounds: bounds)
        let rightViewRect = rightViewRect(forBounds: bounds)
        let textWidth = rightViewRect.minX - leftViewRect.maxX - Constants.textHorizontalInset * 2
        return CGRect(
            x: leftViewRect.maxX + Constants.textHorizontalInset,
            y: bounds.origin.y + Constants.paddedTextFieldInsets.top,
            width: textWidth,
            height: bounds.size.height - (Constants.paddedTextFieldInsets.top + Constants.paddedTextFieldInsets.bottom)
        )
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.leftViewRect(forBounds: bounds)
        return CGRect(
            x: rect.origin.x + Constants.paddedTextFieldInsets.left,
            y: rect.origin.y,
            width: rect.width,
            height: rect.height
        )
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.rightViewRect(forBounds: bounds)
        return CGRect(
            x: rect.origin.x - Constants.paddedTextFieldInsets.right,
            y: rect.origin.y,
            width: rect.width,
            height: rect.height
        )
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
