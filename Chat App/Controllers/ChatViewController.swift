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
    let cellIdentifier = "messageCell"
    var otherUser: UserData!
    var currentUser: UserData!
    var chatId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        fetchChats()
        configureUI()
    }
    
    let textField: UITextView = {
        let field = UITextView()
        
        field.textColor = ColorConstants.dimTealGreen
        field.textContainerInset = UIEdgeInsets(top: 14, left: 10, bottom: 14, right: 10)
        field.font = FontConstants.normal2
        field.layer.cornerRadius = 25
        field.backgroundColor = ColorConstants.white
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
    
    let picButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageConstants.picture, for: .normal)
        button.tintColor = ColorConstants.white
        button.backgroundColor = ColorConstants.darkTealGreen
        button.layer.cornerRadius = 25
        return button
    }()
    
    let containerView = UIView()
    
    lazy var inputContainerView: UIView = {
        
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let textField = UITextField()
        textField.placeholder = "Message"
        containerView.addSubview(textField)
        textField.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: 50)
        textField.translatesAutoresizingMaskIntoConstraints = false
        let sendButton = UIButton ()
        
        sendButton.setImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
        sendButton.tintColor = .white
        sendButton.backgroundColor = .link
        sendButton.layer.cornerRadius = 25
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = .red
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        sendButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        containerView.addSubview(textField)
        textField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(separatorLineView)
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return containerView
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
        
        navigationItem.title = otherUser.username
        navigationItem.backButtonTitle = ""
        
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        picButton.addTarget(self, action: #selector(handlePic), for: .touchUpInside)
        
        view.addSubview(containerView)
        containerView.addSubview(textField)
        containerView.addSubview(sendButton)
        containerView.addSubview(picButton)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        picButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 60),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            textField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5),
            textField.heightAnchor.constraint(equalToConstant: 50),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
            sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            sendButton.widthAnchor.constraint(equalToConstant: 50),
            
            picButton.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -5),
            picButton.heightAnchor.constraint(equalToConstant: 50),
            picButton.widthAnchor.constraint(equalToConstant: 50),
            
            textField.rightAnchor.constraint(equalTo: picButton.leftAnchor, constant: -5),
            
        ])
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
        
    }
    
    func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    //    func setKeyboardObservers() {
    //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    //
    //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    //    }
    
    @objc func handlePic() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func fetchChats() {
        messages = []
        NetworkManager.shared.fetchMessages(chatId: chat.chatId!) { messages in
            self.messages = messages
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: [0, messages.count - 1], at: .bottom, animated: false)
            }
        }
    }
    
    func configureTableView() {
        
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.register(MessageTableCell.self, forCellReuseIdentifier: cellIdentifier)
        
    }
    
    @objc func handleProfile() {
        
    }
    
    @objc func handleSend() {
        if textField.text != "" {
            let newMessage = Message(sender: currentUser.uid, content: textField.text!, time: Date(), seen: false, imagePath: "")
            
            var messagesArray = messages
            messagesArray.append(newMessage)
            
            NetworkManager.shared.addMessage(messages: messagesArray, lastMessage: newMessage, id: chatId!)
            
            textField.text = ""
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
        
        let messagesItem = messages[indexPath.row]
        cell.messageItem = messagesItem
        
        cell.backgroundColor = ColorConstants.customWhite
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func uploadPhoto(image: UIImage) {
        let path = "Chats/\(chatId!)/\(UUID())"
        let newMessage = Message(sender: self.currentUser.uid, content: "", time: Date(), seen: false, imagePath: path)
        var messagesArray = self.messages
        messagesArray.append(newMessage)
        ImageUploader.uploadImage(image: image, name: path) { url in
            
        }
        NetworkManager.shared.addMessage(messages: messagesArray, lastMessage: newMessage, id: self.chatId!)
        self.tableView.reloadData()
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            uploadPhoto(image: imageSelected)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
