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
        setKeyboardObservers()
        
        // Do any additional setup after loading the view.
    }
    
//    let textField = CustomTextField(placeholder: "Message", color: ColorConstants.tealGreen)
    let textField: UITextView = {
        let field = UITextView()
//        field.text = "Message"
        field.textColor = ColorConstants.dimTealGreen
        field.textContainerInset = UIEdgeInsets(top: 14, left: 10, bottom: 14, right: 10)
        field.font = FontConstants.normal2
        field.centerVertical()
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
            containerView.heightAnchor.constraint(equalToConstant: 50),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            tableView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -5),
            
            textField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5),
            textField.heightAnchor.constraint(equalToConstant: 50),

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
        return containerView
    }
    
    func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func setKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
//        self.view.frame.origin.y = -335
    }
    
    @objc func keyboardWillHide() {
//        self.view.frame.origin.y = 0
    }
    
    @objc func handlePic() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func fetchChats() {
        messages = []
        NetworkManager.shared.fetchMessages(chatId: chat.chatId!) { messages in
            //            print("Messages\(messages)")
            self.messages = messages
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: [0, messages.count - 1], at: .bottom, animated: false)
            }
//            self.tableView.reloadData()
//            self.tableView.scrollToRow(at: [0, messages.count - 1], at: .bottom, animated: false)
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
            let newMessage = Message(sender: currentUser.uid, content: textField.text!, time: Date(), seen: false)
//            messages.append(newMessage)
            var messagesArray = messages
            messagesArray.append(newMessage)
//            messages.append(newMessage)
            
            NetworkManager.shared.addMessage(messages: messagesArray, lastMessage: newMessage, id: chatId!)
            
            textField.text = ""
        }
    }
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func tryWork(message: Message, indexPath: IndexPath) {
        let cell = tableView(tableView, cellForRowAt: indexPath) as! MessageTableCell
        if message.sender == currentUser.uid {
            cell.leftConstraint.isActive = false
            cell.rightConstraint.isActive = true
            cell.message.backgroundColor = ColorConstants.tealGreen
        } else {
            cell.rightConstraint.isActive = false
            cell.leftConstraint.isActive = true
            cell.message.backgroundColor = ColorConstants.grey
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MessageTableCell
        
//        let messageItem =
       
        let messagesItem = messages[indexPath.row]
//        tryWork(message: messagesItem, indexPath: indexPath)
        cell.messageItem = messagesItem
//        cell.senderUid = messageItem.sender
//        cell.currentUid = NetworkManager.shared.getUID()
//        cell.message.text = messageItem.content
        
        
        cell.backgroundColor = ColorConstants.customWhite
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func uploadPhoto(image: UIImage) {
        
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            profileImage.image = imageSelected
//            profileImage.layer.borderColor = ColorConstants.tealGreen.cgColor
            uploadPhoto(image: imageSelected)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
