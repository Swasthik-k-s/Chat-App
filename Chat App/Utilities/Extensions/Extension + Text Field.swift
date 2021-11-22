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
        
//        let textFont = font == nil ? FontConstants.normal2 : font!
//        textContainerInset.top = (frame.height = textFont.lineHeight) / 2
        
//        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
//        print("FittingSize\(fittingSize)")
//        let size = sizeThatFits(fittingSize)
//        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
//        let positiveTopOffset = max(1, topOffset)
//        textContainerInset.top = positiveTopOffset
//        print(positiveTopOffset)
        
//        var topCorrect = (self.bounds.size.height - self.contentSize.height * self.zoomScale) / 2
//        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect
//        self.contentInset.top = topCorrect
//        print(topCorrect)
    }
}

