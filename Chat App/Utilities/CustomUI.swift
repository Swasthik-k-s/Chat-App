//
//  CustomUI.swift
//  Chat App
//
//  Created by Swasthik K S on 13/11/21.
//

import Foundation
import UIKit

class InputFieldView: UIView {
    init(image: UIImage, color: UIColor, textField: UITextField) {
        super.init(frame: .zero)
        backgroundColor = .white
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.borderColor = ColorConstants.customRed.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        translatesAutoresizingMaskIntoConstraints = false
        layer.shadowColor = ColorConstants.darkTealGreen.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowOffset.height = -3
        
        let iv = CustomImageView(image: image, height: 24, width: 24, cornerRadius: 0, color: color)
        addSubview(iv)
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iv.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        
        //        let textField = CustomTextField(placeholder: placeHolder, color: color)
        addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: iv.rightAnchor,constant: 10).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomImageView: UIImageView {
    
    init(image: UIImage, height: CGFloat, width: CGFloat, cornerRadius: CGFloat, color: UIColor) {
        super.init(frame: .zero)
        self.image = image
        layer.cornerRadius = cornerRadius
        tintColor = color
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class menuStackView: UIStackView {
    
}

class CustomLabel: UILabel {
    
    init(text: String, color: UIColor, font: UIFont) {
        super.init(frame: .zero)
        self.text = text
        textColor = color
        self.font = font
        textAlignment = .center
        numberOfLines = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomButton: UIButton {
    
    init(title: String, color: UIColor, textColor: UIColor, font: UIFont, cornerRadius: CGFloat) {
        super.init(frame: .zero)
        backgroundColor = color
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = font
        layer.cornerRadius = cornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomTextField: UITextField {
    
    init(placeholder: String, color: UIColor) {
        super.init(frame: .zero)
        
        font = FontConstants.normal1
        textColor = color
        self.placeholder = placeholder
        autocorrectionType = .no
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
