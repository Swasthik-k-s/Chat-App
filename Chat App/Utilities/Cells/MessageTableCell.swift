//
//  Message.swift
//  Chat App
//
//  Created by Swasthik K S on 19/11/21.
//

import UIKit

class MessageTableCell: UITableViewCell {
    
    //    override func awakeFromNib() {
    //        super.awakeFromNib()
    //        // Initialization code
    //        print("okkkkk")
    //
    //    }
    var messageItem: Message? {
        didSet {
            var isSender = true
            guard let uid = NetworkManager.shared.getUID() else { return }
            if uid != messageItem?.sender {
                isSender = false
            }
            configureCell(isSender: isSender)
//            testConfigure(isSender: isSender)
        }
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
    
    
    func testConfigure(isSender: Bool) {
        message.text = messageItem?.content
        
        
        addSubview(message)
        message.translatesAutoresizingMaskIntoConstraints = false
        
        let right: NSLayoutConstraint = message.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        let left: NSLayoutConstraint = message.leftAnchor.constraint(equalTo: leftAnchor, constant: 10)
        NSLayoutConstraint.activate([
            
            message.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            message.topAnchor.constraint(equalTo: topAnchor, constant: 10),
        ])
        
//        if isSender {
//            left.isActive = false
//            right.isActive = true
//            message.backgroundColor = ColorConstants.tealGreen
//        } else {
//            right.isActive = false
//            left.isActive = true
//            message.backgroundColor = ColorConstants.grey
//        }
    }
    
    func configureCell(isSender: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        
        message.text = messageItem!.content
        time.text = dateFormatter.string(from: messageItem!.time)
        
        //        messageView.backgroundColor = ColorConstants.tealGreen
        messageView.layer.cornerRadius = 10
        
        addSubview(messageView)
        messageView.addSubview(time)
        messageView.addSubview(message)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        leftConstraint = messageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)
        rightConstraint = messageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
        
        if isSender {
//            print("Sender 1\(messageItem?.content)")
            leftConstraint.isActive = false
            rightConstraint.isActive = true
            messageView.backgroundColor = ColorConstants.tealGreen
            
        } else {
//            print("Sender 2\(messageItem?.content)")
            rightConstraint.isActive = false
            leftConstraint.isActive = true
            messageView.backgroundColor = ColorConstants.grey
            
        }
        
        NSLayoutConstraint.activate([
            
            message.widthAnchor.constraint(equalToConstant: 200),
            messageView.widthAnchor.constraint(equalTo: message.widthAnchor, constant: 60),
            messageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            message.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: 10),
            message.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10),
            //            message.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -10),
            
            time.rightAnchor.constraint(equalTo: messageView.rightAnchor, constant: -10),
            time.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 5),
            time.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -10),
            //            time.widthAnchor.constraint(equalToConstant: 60),
            
            
            
//            message.rightAnchor.constraint(equalTo: messageView.rightAnchor, constant: -10),
            
        ])
    }
}
