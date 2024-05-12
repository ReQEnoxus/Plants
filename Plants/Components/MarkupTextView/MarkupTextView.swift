//
//  MarkupTextView.swift
//  Plants
//
//  Created by Никита Афанасьев on 09.05.2024.
//

import UIKit

final class MarkupTextView: UITextView {
    
    // MARK: - Initializers
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupInitialState()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInitialState()
    }
    
    // MARK: - Internal Methods
    
    func setAttributedText(_ text: NSAttributedString) {
        let mutable = NSMutableAttributedString(attributedString: text)
        let fullRange = NSRange(location: .zero, length: mutable.length)
        if let font, let textColor {
            mutable.addAttributes(
                [
                    .font: font,
                    .foregroundColor: textColor
                ],
                range: fullRange
            )
        }
        text.enumerateAttribute(
            .linkAction,
            in: NSRange(location: .zero, length: text.length)
        ) { value, range, _ in
            if value != nil {
                mutable.addAttributes(
                    [.foregroundColor: Assets.Colors.green.color],
                    range: range
                )
            }
        }
        attributedText = mutable
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard !isEditable && !isSelectable && bounds.contains(point)
        else { return super.point(inside: point, with: event) }
        
        guard let pos = closestPosition(to: point) else { return false }
        let index = offset(from: beginningOfDocument, to: pos)
        return textStyling(at: pos, in: .forward)?[.linkAction] != nil && index < attributedText.length
    }
    
    // MARK: - Private Methods
    
    private func setupInitialState() {
        isScrollEnabled = false
        textContainerInset = .zero
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        textContainer.lineFragmentPadding = .zero
        contentMode = .topLeft
        isEditable = false
        isSelectable = false
        textDragInteraction?.isEnabled = false
        backgroundColor = .clear
        setupGestureRecognizer()
    }
    
    private func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        )
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func handleTap(gestureRecognizer: UIGestureRecognizer) {
        let location = gestureRecognizer.location(in: self)
        
        guard bounds.contains(location),
              let position = closestPosition(to: location)
        else { return }
        
        let index = offset(from: beginningOfDocument, to: position)
        
        guard index < attributedText.length,
              let action = textStyling(at: position, in: .forward)?[.linkAction] as? LinkAction
        else { return }
        
        action.closure()
    }
}

extension MarkupTextView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
