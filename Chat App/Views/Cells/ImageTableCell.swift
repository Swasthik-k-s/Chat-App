//
//  ImageTableCell.swift
//  Chat App
//
//  Created by Swasthik K S on 03/12/21.
//

import UIKit

class ImageTableCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(messageView)
        messageView.addSubview(chatImage)
        messageView.addSubview(time)
        
        messageView.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        messageView.layer.cornerRadius = 10
        
        leftConstraint = messageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)
        rightConstraint = messageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
        
        NSLayoutConstraint.activate([
            messageView.widthAnchor.constraint(equalTo: chatImage.widthAnchor, constant: 20),
            messageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),

            chatImage.centerXAnchor.constraint(equalTo: messageView.centerXAnchor),
            chatImage.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10),
            
            time.centerXAnchor.constraint(equalTo: messageView.centerXAnchor),
            time.topAnchor.constraint(equalTo: chatImage.bottomAnchor, constant: 5),
            time.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var messageItem: Message? {
        didSet {
            configureImageCell()
        }
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
    
    var time = CustomLabel(text: "", color: ColorConstants.customWhite, font: FontConstants.small)
    var messageView = UIView()
    
    var leftConstraint: NSLayoutConstraint!
    var rightConstraint: NSLayoutConstraint!
    
    func configureImageCell() {
        
        time.text = dateToStringConvertor(date: messageItem!.time)
        NetworkManager.shared.downloadImageWithPath(path: messageItem!.imagePath, completion: { image in
            DispatchQueue.main.async {
                self.chatImage.image = image
            }
        })
        
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
