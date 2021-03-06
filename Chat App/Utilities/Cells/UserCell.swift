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
    
    var select:Bool = false
    
    var normalView = UIView()
    var editView = UIView()
    var messageView = UIView()
    
    var nameLabel = CustomLabel(text: "", color: .black, font: FontConstants.bold3)
    var messageLabel = CustomLabel(text: "", color: ColorConstants.grey, font: FontConstants.normal1)
    var dateLabel = CustomLabel(text: "", color: ColorConstants.grey, font: FontConstants.small)
                                
    var profileImage = CustomImageView(image: UIImage(systemName: "person.fill")!, height: 50, width: 50, cornerRadius: 25, color: ColorConstants.customWhite)
    
    var selectButton: UIButton = {
        let button = UIButton()
//        button.setTitle("Select", for: .normal)
        button.setImage(ImageConstants.round, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.tintColor = ColorConstants.tealGreen
        button.addTarget(self, action: #selector(handleSelect), for: .touchUpInside)
       
//        button.backgroundColor = .red
        
        return button
    }()
    
    lazy var infoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, messageView])
        stack.spacing = 10
        stack.axis = .vertical
        stack.alignment = .leading
        return stack
    }()
//    let infoStack = UIStackView(arrangedSubviews: [nameLabel, messageLabel])
    
    func configureChat() {
        guard let chat = chat else { return }
        
        let otherUser = chat.users[chat.otherUser!]
        
        nameLabel.text = otherUser.username
        
        lastMessageItem = chat.lastMessage
        
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/YY hh:mm:a"
        dateFormatter.dateFormat = "hh:mm:a"

//        var time = dateFormatter.string(from: chat.lastMessage!.time)
        if chat.lastMessage == nil {
            dateLabel.text = ""
        } else {
            dateLabel.text = dateFormatter.string(from: chat.lastMessage!.time)
        }
        
        NetworkManager.shared.downloadImageWithPath(path: "Profile/\(otherUser.uid)") { image in
            DispatchQueue.main.async {
                self.profileImage.image = image
            }
            
        }
        
    }
    
    func animateView(open: Bool) {
        if open {
            selectButton.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.frame.origin.x = 30
            }, completion: nil)
        } else {
            selectButton.isHidden = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.frame.origin.x = 0
            },completion: nil)
        }
    }
    
//    func selectChat() {
//
//    }
    func selected(isSelect: Bool) {
        if isSelect {
            selectButton.setImage(ImageConstants.roundFill, for: .normal)
        } else {
            selectButton.setImage(ImageConstants.round, for: .normal)
        }
    }
    
    @objc func selectChat() {
        print("Clicked")
    }
    
    func checkLastMessage() {
        messageLabel.text = lastMessageItem?.content
//        messageLabel.numberOfLines = 1
//        print(lastMessageItem?.content)
        let sentImage = UIImageView()
//        if lastMessageItem?.sender != uid {
//
//                sent.image = UIImage(systemName: "checkmark.circle")
//            sentImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
//            sentImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
//            sentImage.contentMode = .scaleAspectFit
//            sentImage.tintColor = lastMessageItem?.seen == false ? ColorConstants.grey : ColorConstants.darkTealGreen
//            sentImage.image = lastMessageItem?.seen == false ? ImageConstants.unseen : ImageConstants.seen
//
//
//            messageView.addSubview(sentImage)
//            sentImage.translatesAutoresizingMaskIntoConstraints = false
//
//            NSLayoutConstraint.activate([
//                sentImage.leftAnchor.constraint(eq)
//                sentImage.leftAnchor.constraint(equalTo: messageView.leftAnchor),
//                sentImage.centerYAnchor.constraint(equalTo: messageView.centerYAnchor),
//
//                messageLabel.centerYAnchor.constraint(equalTo: messageView.centerYAnchor),
//                messageLabel.leftAnchor.constraint(equalTo: sentImage.rightAnchor, constant: 1)
//            ])
//        } else {
//            messageView.willRemoveSubview(sentImage)
//            sentImage.removeFromSuperview()
//            sentImage.isHidden = true
//            NSLayoutConstraint.activate([
//                sentImage.leftAnchor.constraint(eq)
//
//                messageLabel.centerYAnchor.constraint(equalTo: messageView.centerYAnchor),
//                messageLabel.leftAnchor.constraint(equalTo: messageView.leftAnchor)
//            ])
//        }
    }
    
    func configureCell() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectChat))
        editView.addGestureRecognizer(tapGesture)
        
        
//        selectButton.addTarget(self, action: #selector(handleSelect), for: .touchUpInside)
        messageLabel.numberOfLines = 1
        profileImage.backgroundColor = ColorConstants.grey
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
       

//        addSubview(normalView)
//        addSubview(editView)
        addSubview(messageView)
        addSubview(selectButton)
        addSubview(profileImage)
        addSubview(infoStack)
        addSubview(dateLabel)
//        addSubview(selectButton)
//        normalView.addSubview(profileImage)
//        normalView.addSubview(infoStack)
//        normalView.addSubview(dateLabel)

//        editView.addSubview(selectButton)
//        editView.backgroundColor = .red
        
//        insertSubview(editView, at: 0)
        messageView.addSubview(messageLabel)
        
        messageLabel.textAlignment = .left
        messageLabel.widthAnchor.constraint(equalTo: infoStack.widthAnchor).isActive = true
        
//        normalView.translatesAutoresizingMaskIntoConstraints = false
//        editView.translatesAutoresizingMaskIntoConstraints = false
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
//        messageView.backgroundColor = .red
        
        NSLayoutConstraint.activate([
//            normalView.leftAnchor.constraint(equalTo: self.leftAnchor),
//            normalView.rightAnchor.constraint(equalTo: self.rightAnchor),
//            normalView.topAnchor.constraint(equalTo: self.topAnchor),
//            normalView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//
//            editView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: -50),
////            editView.rightAnchor.constraint(equalTo: self.leftAnchor),
//            editView.widthAnchor.constraint(equalToConstant: 50),
//            editView.topAnchor.constraint(equalTo: self.topAnchor),
//            editView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            selectButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: -20),
            selectButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            selectButton.topAnchor.constraint(equalTo: self.topAnchor),
//            selectButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            profileImage.leftAnchor.constraint(equalTo: selectButton.rightAnchor, constant: 0),
            profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//
            infoStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            infoStack.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 10),
            infoStack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -60),

            dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            
//            messageView.leftAnchor.constraint(equalTo: infoStack.leftAnchor),
//            messageView.rightAnchor.constraint(equalTo: infoStack.rightAnchor),
//            messageView.centerYAnchor.constraint(equalTo: infoStack.centerYAnchor)
            
        
        ])
    }
    @objc func handleSelect(sender: UIButton) {
//        print("Selected")
        select = !select
        delegate?.chatSelected(isSelected: select)
        if select {
            selectButton.setImage(ImageConstants.roundFill, for: .normal)
        } else {
            selectButton.setImage(ImageConstants.round, for: .normal)
        }
    }
    
}
