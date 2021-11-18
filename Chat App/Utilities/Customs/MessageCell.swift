//
//  MessageCell.swift
//  Chat App
//
//  Created by Swasthik K S on 17/11/21.
//

import UIKit

class MessageCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var messageView = UIView()
    
    var message = CustomLabel(text: "", color: ColorConstants.customWhite, font: FontConstants.normal1)
    
    var time = CustomLabel(text: "", color: ColorConstants.customWhite, font: FontConstants.small)
    
    var sender: Bool = Bool.random()
    
    func configureCell() {
//        message.backgroundColor = ColorConstants.tealGreen
//        message.layer.cornerRadius = 30
//        message.widthAnchor.constraint(equalToConstant: 200).isActive = true
        message.textAlignment = .left
        messageView.backgroundColor = ColorConstants.tealGreen
        messageView.layer.cornerRadius = 10
        messageView.addSubview(message)
        messageView.addSubview(time)
        addSubview(messageView)
        
//        addSubview(message)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        if sender {
            messageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
            messageView.backgroundColor = ColorConstants.tealGreen
        } else {
            messageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            messageView.backgroundColor = ColorConstants.blue
        }
        
        NSLayoutConstraint.activate([
            
            messageView.widthAnchor.constraint(equalToConstant: 250),
            messageView.topAnchor.constraint(equalTo: topAnchor),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            message.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: 10),
            message.centerYAnchor.constraint(equalTo: messageView.centerYAnchor),
            
            time.rightAnchor.constraint(equalTo: messageView.rightAnchor, constant: -10),
            time.centerYAnchor.constraint(equalTo: messageView.centerYAnchor),
            time.widthAnchor.constraint(equalToConstant: 60),
            
            message.rightAnchor.constraint(equalTo: time.leftAnchor, constant: -10),
            
        ])
    }
}
