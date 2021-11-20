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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("okkk")
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//
//    }

    var messageView = UIView()
    
    var message: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = ColorConstants.customWhite
        label.numberOfLines = 0
        return label
    }()
    
    var time = CustomLabel(text: "", color: ColorConstants.customWhite, font: FontConstants.small)
    
    var sender: Bool?
    var senderUid: String?
    var currentUid: String?
    
    
    func configureCell() {
//        message.backgroundColor = ColorConstants.tealGreen
//        message.layer.cornerRadius = 30
//        message.widthAnchor.constraint(equalToConstant: 200).isActive = true
        message.textAlignment = .left
        message.numberOfLines = 0
        messageView.backgroundColor = ColorConstants.tealGreen
        messageView.layer.cornerRadius = 10

        addSubview(messageView)
        addSubview(time)
        addSubview(message)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            messageView.widthAnchor.constraint(equalToConstant: 300),
            messageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            message.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: 10),
            message.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10),
            message.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -10),
            
            time.rightAnchor.constraint(equalTo: messageView.rightAnchor, constant: -10),
            time.centerYAnchor.constraint(equalTo: messageView.centerYAnchor),
            time.widthAnchor.constraint(equalToConstant: 60),
            
            message.rightAnchor.constraint(equalTo: time.leftAnchor, constant: -10),
            
            
        ])
    }
    
    func checkSender() {
        
        if senderUid == currentUid {
            sender = true
            messageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
//            messageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = false
//            messageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
            messageView.backgroundColor = ColorConstants.tealGreen
            message.textColor = .white
        } else {
            sender = false
            messageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
//            messageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = false
//            messageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
            messageView.backgroundColor = ColorConstants.grey
            message.textColor = .white
        }
        
//        if sender! {
//            
//        } else {
//            
//        }
    }
}
