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
    let messageCellIdentifier = "messageCell"
    let imageCellIdentifier = "imageCell"
    var currentUser: UserData!
    let uid = NetworkManager.shared.getUID()
    var finalArray: [[Message]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        fetchChats()
        configureUI()
    }
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageConstants.send, for: .normal)
        button.tintColor = ColorConstants.white
        button.backgroundColor = ColorConstants.darkTealGreen
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        return button
    }()
    
    let picButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageConstants.picture, for: .normal)
        button.tintColor = ColorConstants.white
        button.backgroundColor = ColorConstants.darkTealGreen
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePic), for: .touchUpInside)
        return button
    }()
    
    lazy var textField: UITextField = {
        let text = UITextField()
        text.placeholder = "Message"
        text.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: 50)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = ColorConstants.white
        text.layer.cornerRadius = 25
        text.textColor = ColorConstants.tealGreen
        text.leftPadding(value: 10)
        text.rightPadding(value: 10)
        return text
    }()
    
    lazy var inputContainerView: UIView = {
        
        let containerView = UIView()
//        containerView.backgroundColor = .red
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(textField)
        
        let separatorLineView = UIView()
//        separatorLineView.backgroundColor = .red
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(sendButton)
        containerView.addSubview(picButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        picButton.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -5).isActive = true
        picButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        picButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        picButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        containerView.addSubview(textField)
        textField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: picButton.leftAnchor, constant: -5).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        containerView.addSubview(separatorLineView)
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return containerView
    }()
    
    func configureUI() {
        
        let info = UIBarButtonItem(image: ImageConstants.info, style: .plain, target: self, action: #selector(handleInfo))
        
        if chat.isGroupChat {
            navigationItem.rightBarButtonItems = [info]
        }
        
        view.backgroundColor = ColorConstants.customWhite
        var name: String
        
        NetworkManager.shared.fetchUser(uid: uid!, completion: { user in
            self.currentUser = user
        })
        if chat.isGroupChat {
            name = chat.groupName!
        } else {
            if chat.users[0].uid == uid {
                name = chat.users[1].username
            } else {
                name = chat.users[0].username
            }
        }
        
        navigationItem.title = name
        navigationItem.backButtonTitle = ""
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
            return true
        }
    
    @objc func handleInfo() {
        var usersString = ""
        for user in chat.users {
            usersString = "\(usersString) | \(user.username)"
        }
        showAlert(title: "Number of Group Members: \(chat.users.count)", message: usersString)
    }
    
    @objc func handlePic() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func dateToStringConvertor(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        
        return dateFormatter.string(from: date)
    }
    
    func fetchChats() {
        messages = []
        finalArray = []
        
        NetworkManager.shared.fetchMessages(chatId: chat.chatId!) { messages in
            self.messages = messages

            var msgDate: String? = ""
            var dateMsgArray: [Message] = []
            self.finalArray = []
            for message in messages {
                if msgDate == "" {
                    msgDate = self.dateToStringConvertor(date: message.time)
                    dateMsgArray.append(message)
                } else {
                    if msgDate == self.dateToStringConvertor(date: message.time) {
                        dateMsgArray.append(message)
                    } else {
                        self.finalArray.append(dateMsgArray)
                        msgDate = ""
                        dateMsgArray.removeAll()
                        dateMsgArray.append(message)
                    }
                }
            }
            
            self.finalArray.append(dateMsgArray)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
//                self.tableView.scrollToRow(at: [0, self.messages.count - 1], at: .bottom, animated: false)
                self.tableView.scrollToRow(at: [self.finalArray.count - 1, self.finalArray[self.finalArray.count - 1].count - 1], at: .bottom, animated: false)
            }
        }
    }
    
    func configureTableView() {
        tableView.isUserInteractionEnabled = true
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.register(MessageTableCell.self, forCellReuseIdentifier: messageCellIdentifier)
        tableView.register(ImageTableCell.self, forCellReuseIdentifier: imageCellIdentifier)
        tableView.alwaysBounceVertical = true
    }
    
    @objc func handleProfile() {
        
    }
    
    @objc func handleSend() {
        if textField.text != "" {
            let newMessage = Message(sender: currentUser.uid, content: textField.text!, time: Date(), seen: false, imagePath: "")
            
            NetworkManager.shared.addMessage(lastMessage: newMessage, id: chat.chatId!)
            
            textField.text = ""
        }
    }
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return finalArray.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let date = finalArray[section].first!.time

        let dateView = UIView()
        dateView.layer.cornerRadius = 5

        let dateLabel = UILabel()
        dateLabel.textAlignment = .center
        dateLabel.backgroundColor = ColorConstants.blue
        dateLabel.textColor = .black
        dateLabel.font = FontConstants.bold1
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = dateToStringConvertor(date: date)
        dateLabel.layer.masksToBounds = true

        dateView.addSubview(dateLabel)

        dateLabel.centerYAnchor.constraint(equalTo: dateView.centerYAnchor).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: dateView.centerXAnchor).isActive = true

        let contentSize = dateLabel.intrinsicContentSize
        dateLabel.widthAnchor.constraint(equalToConstant: contentSize.width + 20).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: contentSize.height + 10).isActive = true
        dateLabel.layer.cornerRadius = 10

        return dateView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count
        return finalArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if messages[indexPath.row].imagePath == "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: messageCellIdentifier, for: indexPath) as! MessageTableCell
//            cell.messageItem = messages[indexPath.row]
            cell.messageItem = finalArray[indexPath.section][indexPath.row]
            cell.usersList = chat.users
            cell.backgroundColor = ColorConstants.customWhite
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: imageCellIdentifier, for: indexPath) as! ImageTableCell
            cell.messageItem = messages[indexPath.row]
            cell.usersList = chat.users
            NetworkManager.shared.downloadImageWithPath(path: messages[indexPath.row].imagePath, completion: { image in
                DispatchQueue.main.async {
                    cell.chatImage.image = image
                }
            })

            cell.backgroundColor = ColorConstants.customWhite
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func uploadPhoto(image: UIImage) {
        let path = "Chats/\(chat.chatId!)/\(UUID())"
        let newMessage = Message(sender: self.currentUser.uid, content: "", time: Date(), seen: false, imagePath: path)

        ImageUploader.uploadImage(image: image, name: path) { url in
            
        }
        NetworkManager.shared.addMessage(lastMessage: newMessage, id: self.chat.chatId!)
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
