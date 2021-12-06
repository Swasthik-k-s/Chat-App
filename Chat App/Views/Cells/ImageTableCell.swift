//
//  ImageTableCell.swift
//  Chat App
//
//  Created by Swasthik K S on 03/12/21.
//

import UIKit

class ImageTableCell: UITableViewCell {
    
    var time = CustomLabel(text: "", color: ColorConstants.customWhite, font: FontConstants.small)
    var messageView = UIView()
    
    var leftConstraint: NSLayoutConstraint!
    var rightConstraint: NSLayoutConstraint!
    var currentSenderTopConstraint: NSLayoutConstraint!
    var receiverMesageTopCpnstraint: NSLayoutConstraint!
    var senderNameTopConstraint: NSLayoutConstraint!
    
    var senderName: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = ColorConstants.blue
        label.textAlignment = .left
        label.font = FontConstants.bold1
        return label
    }()
    
    var usersList: [UserData]? {
        didSet {
            configureSenderData()
        }
    }
    
    var messageItem: Message? {
        didSet {
            configureImageCell()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(messageView)
        messageView.addSubview(chatImage)
        messageView.addSubview(time)
        messageView.addSubview(senderName)
        
        messageView.translatesAutoresizingMaskIntoConstraints = false
        senderName.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        messageView.layer.cornerRadius = 10
        
        leftConstraint = messageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)
        rightConstraint = messageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
        currentSenderTopConstraint = chatImage.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10)
        receiverMesageTopCpnstraint = chatImage.topAnchor.constraint(equalTo: senderName.bottomAnchor, constant: 5)
        senderNameTopConstraint = senderName.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10)
        
        NSLayoutConstraint.activate([
            messageView.widthAnchor.constraint(equalTo: chatImage.widthAnchor, constant: 20),
            messageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),

            senderName.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: 10),
//            senderName.widthAnchor.constraint(equalToConstant: 80),
            
            chatImage.centerXAnchor.constraint(equalTo: messageView.centerXAnchor),
//            chatImage.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10),
            
            time.centerXAnchor.constraint(equalTo: messageView.centerXAnchor),
            time.topAnchor.constraint(equalTo: chatImage.bottomAnchor, constant: 5),
            time.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func configureImageCell() {
        
        time.text = dateToStringConvertor(date: messageItem!.time)
        NetworkManager.shared.downloadImageWithPath(path: messageItem!.imagePath, completion: { image in
            DispatchQueue.main.async {
                self.chatImage.image = image
            }
        })
        
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
