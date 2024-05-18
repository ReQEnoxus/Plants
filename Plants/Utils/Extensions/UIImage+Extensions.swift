//
//  UIImage+Extensions.swift
//  Plants
//
//  Created by Никита Афанасьев on 18.05.2024.
//

import UIKit

extension UIImage {
    
    func withText(text: String) -> UIImage? {
        let fontSize: CGFloat = 36 / 441 * size.height
        let textColor = UIColor.white
        let textFont = FontFamily.Urbanist.bold.font(size: fontSize)

        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)

        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        draw(in: CGRect(origin: .zero, size: size))
        
        let textRect = NSString(string: text).boundingRect(
            with: CGSize(width: size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: textFontAttributes,
            context: nil
        )
        
        let point = CGPoint(
            x: (size.width - textRect.width) / 2,
            y: size.height - 24 - textRect.height
        )

        text.draw(in: CGRect(origin: point, size: size), withAttributes: textFontAttributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
