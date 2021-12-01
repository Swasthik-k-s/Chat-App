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
            var isSender: Bool
            guard let uid = NetworkManager.shared.getUID() else { return }
            
            if uid != messageItem?.sender {
                isSender = false
            } else {
                isSender = true
            }
            
            if messageItem!.imagePath! == "" {
                configureCell(isSender: isSender)
            } else {
                configureImageCell(isSender: isSender)
            }
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
    
    var chatImage: UIImageView = {
        let image = UIImageView()
        image.widthAnchor.constraint(equalToConstant: 200).isActive = true
        image.heightAnchor.constraint(equalToConstant: 200).isActive = true
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = ImageConstants.picture
        return image
    }()
    
    var time = CustomLabel(text: "", color: ColorConstants.customWhite, font: FontConstants.small)
    
    func configureImageCell(isSender: Bool) {
        
        time.text = dateToStringConvertor(date: messageItem!.time)
        NetworkManager.shared.downloadImageWithPath(path: messageItem!.imagePath!, completion: { image in
            DispatchQueue.main.async {
                self.chatImage.image = image
            }
        })
        
        messageView.backgroundColor = isSender ? ColorConstants.tealGreen : ColorConstants.grey
        messageView.layer.cornerRadius = 10
        
        addSubview(messageView)
        messageView.addSubview(chatImage)
        messageView.addSubview(time)
        
        messageView.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageView.widthAnchor.constraint(equalTo: chatImage.widthAnchor, constant: 20),
            messageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            messageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            chatImage.centerXAnchor.constraint(equalTo: messageView.centerXAnchor),
            chatImage.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10),
            
            time.centerXAnchor.constraint(equalTo: messageView.centerXAnchor),
            time.topAnchor.constraint(equalTo: chatImage.bottomAnchor, constant: 5),
            time.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -10),
        ])
    }
    
    func configureCell(isSender: Bool) {
        
        message.text = messageItem!.content
        time.text = dateToStringConvertor(date: messageItem!.time)
        messageView.layer.cornerRadius = 10
        
        addSubview(messageView)
        messageView.addSubview(time)
        messageView.addSubview(message)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        //        leftConstraint = messageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)
        //        rightConstraint = messageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
        
        if isSender {
            //            leftConstraint.isActive = false
            //            rightConstraint.isActive = true
            messageView.backgroundColor = ColorConstants.tealGreen
            
        } else {
            //            rightConstraint.isActive = false
            //            leftConstraint.isActive = true
            messageView.backgroundColor = ColorConstants.grey
            
        }
        
        NSLayoutConstraint.activate([
            
            message.widthAnchor.constraint(equalToConstant: 200),
            messageView.widthAnchor.constraint(equalTo: message.widthAnchor, constant: 60),
            messageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            messageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            message.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: 10),
            message.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10),
            
            time.rightAnchor.constraint(equalTo: messageView.rightAnchor, constant: -10),
            time.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 5),
            time.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -10),
        ])
    }
    
    func dateToStringConvertor(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        
        return dateFormatter.string(from: date)
    }
}
