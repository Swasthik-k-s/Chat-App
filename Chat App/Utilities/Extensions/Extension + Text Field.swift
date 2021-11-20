//
//  Extension + Text Field.swift
//  Chat App
//
//  Created by Swasthik K S on 19/11/21.
//

import Foundation
import UIKit

extension CustomTextField {
    func leftPadding(value: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func rightPadding(value: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UITextView {
    
    
    func centerVertical() {
        
    }
}

