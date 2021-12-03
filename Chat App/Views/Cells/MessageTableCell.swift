//
//  Message.swift
//  Chat App
//
//  Created by Swasthik K S on 19/11/21.
//

import UIKit

class MessageTableCell: UITableViewCell {
    
    var messageItem: Message? {
        didSet {
            configureCell()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(messageView)
        messageView.addSubview(time)
        messageView.addSubview(message)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        messageView.layer.cornerRadius = 10
        
        leftConstraint = messageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)
        rightConstraint = messageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
        
        NSLayoutConstraint.activate([
            
            message.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            messageView.widthAnchor.constraint(equalTo: message.widthAnchor, constant: 60),
            messageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            //            messageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            message.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: 10),
            message.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10),
            
            time.rightAnchor.constraint(equalTo: messageView.rightAnchor, constant: -10),
            time.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 5),
            time.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var messageView = UIView()
    
    var leftConstraint: NSLayoutConstraint!
    var rightConstraint: NSLayoutConstraint!
    
    var message: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = ColorConstants.customWhite
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    var time = CustomLabel(text: "", color: ColorConstants.customWhite, font: FontConstants.small)
    
    func configureCell() {
        
        message.text = messageItem!.content
        time.text = dateToStringConvertor(date: messageItem!.time)
        
        if messageItem?.sender == NetworkManager.shared.getUID(){
            leftConstraint.isActive = false
            rightConstraint.isActive = true
            messageView.backgroundColor = ColorConstants.tealGreen
            
        } else {
            rightConstraint.isActive = false
            leftConstraint.isActive = true
            messageView.backgroundColor = ColorConstants.grey
            
        }
    }
}
