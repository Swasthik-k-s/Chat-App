//
//  Message.swift
//  Chat App
//
//  Created by Swasthik K S on 19/11/21.
//

import UIKit

class MessageTableCell: UITableViewCell {
    
//    var isGroupChat: Bool?
    
    var messageView = UIView()
    
    var leftConstraint: NSLayoutConstraint!
    var rightConstraint: NSLayoutConstraint!
    var currentSenderTopConstraint: NSLayoutConstraint!
    var receiverMesageTopCpnstraint: NSLayoutConstraint!
    var senderNameTopConstraint: NSLayoutConstraint!
    
    var message: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = ColorConstants.customWhite
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    var senderName: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = ColorConstants.blue
        label.textAlignment = .left
        label.font = FontConstants.bold1
        return label
    }()
    
    var time = CustomLabel(text: "", color: ColorConstants.customWhite, font: FontConstants.small)
    
    var messageItem: Message? {
        didSet {
            configureCell()
        }
    }
    
    var usersList: [UserData]? {
        didSet {
            configureSenderData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(messageView)
        messageView.addSubview(time)
        messageView.addSubview(message)
        messageView.addSubview(senderName)
        
        messageView.translatesAutoresizingMaskIntoConstraints = false
        senderName.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        messageView.layer.cornerRadius = 10
        
        leftConstraint = messageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)
        rightConstraint = messageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
        currentSenderTopConstraint = message.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10)
        receiverMesageTopCpnstraint = message.topAnchor.constraint(equalTo: senderName.bottomAnchor, constant: 5)
        senderNameTopConstraint = senderName.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10)
        
        NSLayoutConstraint.activate([
            
            message.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            messageView.widthAnchor.constraint(equalTo: message.widthAnchor, constant: 80),
            messageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            senderName.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: 10),
            senderName.widthAnchor.constraint(equalToConstant: 80),
            
            message.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: 10),
            
            time.rightAnchor.constraint(equalTo: messageView.rightAnchor, constant: -10),
            time.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 5),
            time.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        
        message.text = messageItem!.content
        time.text = dateToStringConvertor(date: messageItem!.time)
        
        if messageItem?.sender == NetworkManager.shared.getUID(){
            senderName.isHidden = true
            receiverMesageTopCpnstraint.isActive = false
            senderNameTopConstraint.isActive = false
            currentSenderTopConstraint.isActive = true
            leftConstraint.isActive = false
            rightConstraint.isActive = true
            messageView.backgroundColor = ColorConstants.tealGreen
            
        } else {
            senderName.isHidden = false
            currentSenderTopConstraint.isActive = false
            receiverMesageTopCpnstraint.isActive = true
            senderNameTopConstraint.isActive = true
            rightConstraint.isActive = false
            leftConstraint.isActive = true
            messageView.backgroundColor = ColorConstants.grey
            
        }
    }
    
    func configureSenderData() {
        for user in usersList! {
            if messageItem?.sender == user.uid {
                senderName.text = user.username
            }
        }
    }
}
