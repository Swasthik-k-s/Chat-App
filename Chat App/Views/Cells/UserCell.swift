//
//  ChatCell.swift
//  Chat App
//
//  Created by Swasthik K S on 15/11/21.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    var delegate: ChatSelectedDelegate?
    let uid = NetworkManager.shared.getUID()
    var chat: Chats? {
        didSet {
            configureChat()
        }
    }
    
    var lastMessageItem: Message? {
        didSet {
            checkLastMessage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    var select:Bool = false
    
    var normalView = UIView()
    var editView = UIView()
    var messageView = UIView()
    
    var nameLabel = CustomLabel(text: "", color: ColorConstants.titleText, font: FontConstants.bold3)
    var messageLabel = CustomLabel(text: "", color: ColorConstants.labelText, font: FontConstants.normal1)
    var dateLabel = CustomLabel(text: "", color: ColorConstants.labelText, font: FontConstants.small)
    
    var profileImage = CustomImageView(image: UIImage(systemName: "person.fill")!, height: 50, width: 50, cornerRadius: 25, color: ColorConstants.customWhite)
    
//    var selectButton: UIButton = {
//        let button = UIButton()
//        button.setImage(ImageConstants.round, for: .normal)
//        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        button.tintColor = ColorConstants.tealGreen
//        button.addTarget(self, action: #selector(handleSelect), for: .touchUpInside)
//
//        return button
//    }()
    
    lazy var infoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, messageView])
        stack.spacing = 10
        stack.axis = .vertical
        stack.alignment = .leading
        return stack
    }()
    
    func configureChat() {
        guard let chat = chat else { return }
        
        if chat.isGroupChat {
            nameLabel.text = chat.groupName
            NetworkManager.shared.downloadImageWithPath(path: chat.groupIconPath!) { image in
                DispatchQueue.main.async {
                    self.profileImage.image = image
                }
            }
        } else {
            let otherUser = chat.users[chat.otherUser!]
            nameLabel.text = otherUser.username
            NetworkManager.shared.downloadImageWithPath(path: "Profile/\(otherUser.uid)") { image in
                DispatchQueue.main.async {
                    self.profileImage.image = image
                }
            }
        }
        
        lastMessageItem = chat.lastMessage
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
//        dateFormatter.dateFormat = "hh:mm:a"
        
        if chat.lastMessage == nil {
            dateLabel.text = ""
        } else {
            let chatDate = dateFormatter.string(from: chat.lastMessage!.time)
            let currentDate = dateFormatter.string(from: Date())
            if chatDate.compare(currentDate) == .orderedSame {
                dateFormatter.dateFormat = "hh:mm:a"
                dateLabel.text = dateFormatter.string(from: chat.lastMessage!.time)
            } else {
                dateLabel.text = dateFormatter.string(from: chat.lastMessage!.time)
            }
        }
    }
    
//    func animateView(open: Bool) {
//        if open {
//            selectButton.isHidden = false
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
//                self.frame.origin.x = 30
//            }, completion: nil)
//        } else {
//            selectButton.isHidden = true
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
//                self.frame.origin.x = 0
//            },completion: nil)
//        }
//    }
    
//    func selected(isSelect: Bool) {
//        if isSelect {
//            selectButton.setImage(ImageConstants.roundFill, for: .normal)
//        } else {
//            selectButton.setImage(ImageConstants.round, for: .normal)
//        }
//    }
    
    @objc func selectChat() {
        print("Clicked")
    }
    
    func checkLastMessage() {
        if lastMessageItem?.content == "" {
            messageLabel.text = "Photo"
            messageLabel.textColor = ColorConstants.blue
        } else {
            messageLabel.text = lastMessageItem?.content
            messageLabel.textColor = ColorConstants.grey
        }
        
    }
    
    func configureCell() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectChat))
        editView.addGestureRecognizer(tapGesture)
        
        messageLabel.numberOfLines = 1
        nameLabel.numberOfLines = 1
        profileImage.backgroundColor = ColorConstants.grey
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        
        addSubview(messageView)
//        addSubview(selectButton)
        addSubview(profileImage)
        addSubview(infoStack)
        addSubview(dateLabel)
        
        messageView.addSubview(messageLabel)
        
        messageLabel.textAlignment = .left
        messageLabel.widthAnchor.constraint(equalTo: infoStack.widthAnchor).isActive = true
        
//        selectButton.translatesAutoresizingMaskIntoConstraints = false
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
//            selectButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: -20),
//            selectButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            infoStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            infoStack.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 10),
            infoStack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -60),
            
            dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
        ])
    }
//    @objc func handleSelect(sender: UIButton) {
//        select = !select
//        delegate?.chatSelected(isSelected: select)
//        if select {
//            selectButton.setImage(ImageConstants.roundFill, for: .normal)
//        } else {
//            selectButton.setImage(ImageConstants.round, for: .normal)
//        }
//    }
    
}
