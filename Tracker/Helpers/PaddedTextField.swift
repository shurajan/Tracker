//
//  PaddedTextField.swift
//  Tracker
//
//  Created by Alexander Bralnin on 14.10.2024.
//
import UIKit

class PaddedTextField: UITextField {
    
    var textPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
}
