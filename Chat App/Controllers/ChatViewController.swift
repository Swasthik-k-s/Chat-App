//
//  ChatViewController.swift
//  Chat App
//
//  Created by Swasthik K S on 17/11/21.
//

import UIKit

class ChatViewController: UITableViewController, UITextViewDelegate {
    
    var chat: Chats!
    var messages: [Message] = []
    let cellIdentifier = "chatCell"
    var collectionView: UICollectionView!
    var otherUser: UserData!
    var currentUser: UserData!
    var chatId: String?
    
//    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
//        configureCollectionView()
        configureTableView()
        fetchChats()
        configureUI()
        
        
        // Do any additional setup after loading the view.
    }
    
//    let textField = CustomTextField(placeholder: "Message", color: ColorConstants.tealGreen)
    let textField: UITextView = {
        let field = UITextView()
        field.text = "Message"
        field.textColor = ColorConstants.dimTealGreen
//        field.textContainer.size = CGSize(width: 100, height: 40)
//        field.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        field.textContainerInset = UIEdgeInsets(top: 14, left: 10, bottom: 14, right: 10)
        field.font = FontConstants.normal2
        field.centerVertical()
//        field.textAlignment = .center
        return field
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageConstants.send, for: .normal)
        button.tintColor = ColorConstants.white
        button.backgroundColor = ColorConstants.darkTealGreen
        button.layer.cornerRadius = 25
        return button
        
        
    }()
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == ColorConstants.dimTealGreen {
            textView.text = ""
            textView.textColor = ColorConstants.tealGreen
        } else {
            if textView.text == "" {
                textView.text = "Message"
                textView.textColor = ColorConstants.dimTealGreen
            }
        }
    }

    func configureUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        textField.delegate = self
        view.backgroundColor = ColorConstants.customWhite
        chatId = "\(chat.users[0].uid)_\(chat.users[1].uid)"
        
        if chat.otherUser == 0 {
            otherUser = chat.users[0]
            currentUser = chat.users[1]
        } else {
            otherUser = chat.users[1]
            currentUser = chat.users[0]
        }
        
//        view.backgroundColor = .white
        
        navigationItem.title = otherUser.username
        navigationItem.backButtonTitle = ""
        
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        textField.layer.cornerRadius = 25

        textField.backgroundColor = ColorConstants.white
        
        view.addSubview(textField)
        view.addSubview(sendButton)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            textField.heightAnchor.constraint(equalToConstant: 50),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -70),
            
            sendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            sendButton.widthAnchor.constraint(equalToConstant: 50),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            textField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -5),
            
        ])
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -335
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func fetchChats() {
        messages = []
        NetworkManager.shared.fetchMessages(chatId: chat.chatId!) { messages in
//            print("Messages\(messages)")
            self.messages = messages
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func configureTableView() {

//        tableView = UITableView(frame: view.bounds)
//        tableView.dataSource = self
//        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(MessageTableCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    @objc func handleProfile() {
        
    }
    
    @objc func handleSend() {
        if textField.text != "" {
            let newMessage = Message(sender: currentUser.uid, content: textField.text!, time: Date(), seen: false)
//            messages.append(newMessage)
            var messagesArray = messages
            messagesArray.append(newMessage)
//            messages.append(newMessage)
            
            NetworkManager.shared.addMessage(messages: messagesArray, lastMessage: newMessage, id: chatId!)
            
            textField.text = ""
//            textViewDidEndEditing(textField)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
////                self.collectionView.reloadData()
//            }
        }
    }
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MessageTableCell
        
//        let messageItem =
       
        cell.messageItem = messages[indexPath.row]
        
//        cell.senderUid = messageItem.sender
//        cell.currentUid = NetworkManager.shared.getUID()
//        cell.message.text = messageItem.content
        cell.backgroundColor = ColorConstants.customWhite
//        cell.checkSender()
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "hh:mm:a"
//
//        cell.time.text = dateFormatter.string(from: messageItem.time)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
