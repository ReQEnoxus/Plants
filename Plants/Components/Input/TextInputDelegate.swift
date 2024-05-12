//
//  TextInputDelegate.swift
//  Plants
//
//  Created by Никита Афанасьев on 09.05.2024.
//

import Foundation

protocol TextInputDelegate: AnyObject {
    func textInputDidChange(_ textInput: TextInputView)
    func textInputDidEndEditing(_ textInput: TextInputView)
    func textInputDidBeginEditing(_ textInput: TextInputView)
    func textInputShouldReturn(_ textInput: TextInputView) -> Bool
}

extension TextInputDelegate {
    
    func textInputDidChange(_ textInput: TextInputView) {}
    func textInputDidEndEditing(_ textInput: TextInputView) {}
    func textInputDidBeginEditing(_ textInput: TextInputView) {}
    func textInputShouldReturn(_ textInput: TextInputView) -> Bool { return true }
}
