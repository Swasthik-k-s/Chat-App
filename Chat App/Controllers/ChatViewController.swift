//
//  ChatViewController.swift
//  Chat App
//
//  Created by Swasthik K S on 17/11/21.
//

import UIKit

class ChatViewController: UIViewController, UICollectionViewDelegate  {
    
    var chat: Chats!
//    var messages: [Message] = []
    let cellIdentifier = "chatCell"
    var collectionView: UICollectionView!
    var otherUser: UserData!
    var currentUser: UserData!
    var chatId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
        configureUI()
        
        // Do any additional setup after loading the view.
    }
    
    let textField = CustomTextField(placeholder: "Message", color: ColorConstants.tealGreen)
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageConstants.send, for: .normal)
        button.tintColor = ColorConstants.white
        button.backgroundColor = ColorConstants.tealGreen
        button.layer.cornerRadius = 25
        return button
        
        
    }()
    
    func configureUI() {
        chatId = "\(chat.users[0].uid)_\(chat.users[1].uid)"
        
        if chat.otherUser == 0 {
            otherUser = chat.users[0]
            currentUser = chat.users[1]
        } else {
            otherUser = chat.users[1]
            currentUser = chat.users[0]
        }
        
        view.backgroundColor = .white
        
        navigationItem.title = otherUser.username
        navigationItem.backButtonTitle = ""
        
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        textField.layer.cornerRadius = 25
        textField.leftPadding(value: 10)
        textField.rightPadding(value: 10)
        textField.backgroundColor = ColorConstants.customWhite
        
        view.addSubview(textField)
        view.addSubview(sendButton)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            textField.heightAnchor.constraint(equalToConstant: 50),
            
            sendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            sendButton.widthAnchor.constraint(equalToConstant: 50),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            textField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -5)
            
        ])
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellIdentifier)
//        let width = collectionView.frame.width - 50
        
        
        
//        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
    }
    
    @objc func handleProfile() {
        
    }
    
    @objc func handleSend() {
        if textField.text != "" {
            let newMessage = Message(sender: currentUser.uid, content: textField.text!, time: Date(), seen: false)
            chat.messages?.append(newMessage)
            chat.lastMessage = newMessage
//            messages.append(newMessage)
            
            NetworkManager.shared.addMessage(chat: chat, id: chatId!)
            
            textField.text = ""
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension ChatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chat.messages!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MessageCell
        
        let messageItem = chat.messages![indexPath.row]
        
//        if messageItem.sender == currentUser.uid {
//            cell.sender = true
//        } else {
//            cell.sender = false
//        }
       
        cell.senderUid = messageItem.sender
        cell.currentUid = NetworkManager.shared.getUID()
        
        cell.message.text = messageItem.content
        
        cell.checkSender()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        
        cell.time.text = dateFormatter.string(from: messageItem.time)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let chat = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: indexPath) as? MessageCell {
//            print("User Value\(chat)")
//
//            print(chat.message.text)
            let size = CGSize(width: 110, height: 1000)
    
//        let estimatedFrame = NSString(string: chat.message!)
    
            let attribute = chat.message.frame.height
//        let estimatedFrame = NSAttributedString(string: chat.message.text!, attributes: nil)
            let estimatedFrame = NSString(string: chat.message.text!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [:], context: nil)
//            print(estimatedFrame.size)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 40)
//
        }
      
        return CGSize(width: view.frame.width, height: 50)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
}

