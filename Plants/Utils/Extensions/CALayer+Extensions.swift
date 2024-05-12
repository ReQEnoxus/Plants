//
//  CALayer+Extensions.swift
//  Plants
//
//  Created by Никита Афанасьев on 09.05.2024.
//

import UIKit

extension CALayer {
    
    private static let divider: CGFloat = 2
    
    func applySketchShadow(properties: SketchShadow) {
        self.shadowColor = properties.color.cgColor
        self.shadowOpacity = properties.alpha
        self.shadowOffset = CGSize(width: properties.x, height: properties.y)
        self.shadowRadius = properties.blur / CALayer.divider
        if properties.spread == .zero {
            self.shadowPath = nil
        } else {
            let dx = -properties.spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            self.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: properties.cornerRadius).cgPath
        }
    }
    
    struct SketchShadow {
        public var color: UIColor
        public var alpha: Float
        public var x: CGFloat
        public var y: CGFloat
        public var blur: CGFloat
        public var spread: CGFloat
        public var cornerRadius: CGFloat
        
        public init(color: UIColor, alpha: Float, x: CGFloat, y: CGFloat, blur: CGFloat, spread: CGFloat, cornerRadius: CGFloat) {
            self.color = color
            self.alpha = alpha
            self.x = x
            self.y = y
            self.blur = blur
            self.spread = spread
            self.cornerRadius = cornerRadius
        }
    }
}
