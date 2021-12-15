//
//  Extension + Text Field.swift
//  Chat App
//
//  Created by Swasthik K S on 19/11/21.
//

import Foundation
import UIKit

extension UITextField {
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

extension UIButton {
    func pulseEffect() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.80
        pulse.toValue = 1
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
}

extension CustomButton {
    func flashEffect() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.6
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        layer.add(flash, forKey: nil)
    }
    
    func shakeEffect() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 4
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: nil)
        
    }
    
    func buttonAnimation(effectType: String, delay: Double, action: @escaping() -> Void) {
        if effectType == "shake" {
            shakeEffect()
        } else {
            flashEffect()
        }
            isEnabled = false
            let delayTime = DispatchTime.now() + delay
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                action()
                self.isEnabled = true
            })
    }
}


