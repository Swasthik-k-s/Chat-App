//
//  CreateGroupChatViewController.swift
//  Chat App
//
//  Created by Swasthik K S on 05/12/21.
//

import UIKit

class CreateGroupChatViewController: UIViewController, UICollectionViewDelegate {

    let cellIdentifier = "userCell"
    var users: [UserData] = []
    var collectionView: UICollectionView!
    var selectedUsers: [IndexPath] = []
    var currentUser: UserData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureCollectionView()
        configureUI()
        fetchAllUser()
    }
    
    let groupPhotoLabel = CustomLabel(text: "Group Photo", color: ColorConstants.tealGreen, font: FontConstants.bold1)
    
    let groupPhoto = CustomImageView(image: ImageConstants.groupPhoto!, height: 100, width: 100, cornerRadius: 50, color: ColorConstants.tealGreen)
    
    let groupNameLabel = CustomLabel(text: "Group Name", color: ColorConstants.tealGreen, font: FontConstants.bold1)
    
    let groupName = CustomTextField(placeholder: "Enter Group Name", color: ColorConstants.tealGreen)
    
    lazy var groupNameContainer: InputFieldView = {
        return InputFieldView(image: ImageConstants.groupPhoto!, color: ColorConstants.tealGreen, textField: groupName)
    }()
    
    let selectUsersLabel = CustomLabel(text: "Select Users", color: ColorConstants.tealGreen, font: FontConstants.bold1)
    
    @objc func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc func handleCreate() {
        let validateResult = validateGroupChat(groupPhoto: groupPhoto.image!, groupName: groupName.text!, selectedUsersCount: selectedUsers.count)
        if validateResult == "" {
            let chatVC = ChatViewController()
            var vcArray = navigationController?.viewControllers
            vcArray?.removeLast()
            vcArray?.removeLast()
            
            let chatID = "\(groupName.text!)_\(UUID())"
            let groupPhotoPath = "Profile/\(chatID)"
            var usersList: [UserData] = []
            usersList.append(currentUser)
            
            for indexPath in selectedUsers {
                let user = users[indexPath.row]
                usersList.append(user)
            }
            ImageUploader.uploadImage(image: groupPhoto.image!, name: groupPhotoPath) { url in
                
            }
            NetworkManager.shared.addChat(users: usersList, id: chatID, isGroupChat: true, groupName: groupName.text, groupIconPath: groupPhotoPath)
            
            chatVC.chat = Chats(chatId: groupPhotoPath, users: usersList, lastMessage: nil, messages: [], isGroupChat: true, groupName: groupName.text, groupIconPath: groupPhotoPath)
            
            vcArray?.append(chatVC)
            navigationController?.setViewControllers(vcArray!, animated: true)
            
        } else {
            showAlert(title: "Failed", message: validateResult)
        }
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == groupName {
            groupNameContainer.layer.borderColor = groupName.text!.count > 2 ? ColorConstants.tealGreen.cgColor : ColorConstants.customRed.cgColor
        }
    }
    
    func configureUI() {
        groupName.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        let createButton = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(handleCreate))
        navigationItem.rightBarButtonItems = [createButton]
        
        view.backgroundColor = .white
        navigationItem.title = "Create Group Chat"
        navigationItem.backButtonTitle = ""
        
        groupPhoto.layer.borderWidth = 1
        groupPhoto.layer.borderColor = ColorConstants.customRed.cgColor
        groupPhoto.clipsToBounds = true
        groupPhoto.isUserInteractionEnabled = true
        groupPhoto.contentMode = .scaleAspectFit
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentImagePicker))
        groupPhoto.addGestureRecognizer(tapGesture)
        
        view.addSubview(groupPhotoLabel)
        view.addSubview(groupPhoto)
        view.addSubview(groupNameLabel)
        view.addSubview(groupNameContainer)
        view.addSubview(selectUsersLabel)
        
        groupPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        groupPhoto.translatesAutoresizingMaskIntoConstraints = false
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        groupNameContainer.translatesAutoresizingMaskIntoConstraints = false
        selectUsersLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            groupPhotoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            groupPhotoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            groupPhoto.topAnchor.constraint(equalTo: groupPhotoLabel.bottomAnchor, constant: 5),
            groupPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            groupNameLabel.topAnchor.constraint(equalTo: groupPhoto.bottomAnchor, constant: 20),
            groupNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            groupNameContainer.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor, constant: 5),
            groupNameContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            groupNameContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            selectUsersLabel.topAnchor.constraint(equalTo: groupNameContainer.bottomAnchor, constant: 20),
            selectUsersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: selectUsersLabel.bottomAnchor, constant: 5),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func validateGroupChat(groupPhoto: UIImage, groupName: String, selectedUsersCount: Int) -> String {
        if groupPhoto == ImageConstants.groupPhoto {
            return MessageConstants.groupPhotoInvalid
        }
        if groupName.count < 3 {
            return MessageConstants.groupNameInvalid
        }
        if selectedUsersCount < 1 {
            return MessageConstants.minimumGroupMemberError
        }
        return ""
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func fetchAllUser() {
        NetworkManager.shared.fetchAllUsers() { users in
            self.users = users
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension CreateGroupChatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        
        cell.nameLabel.text = user.email
        cell.messageLabel.text = user.username
        cell.dateLabel.isHidden = true
        cell.selectButton.isHidden = true
        if selectedUsers.contains(indexPath) {
            cell.backgroundColor = ColorConstants.tealGreen
        } else {
            cell.backgroundColor = ColorConstants.customWhite
        }
        
        
        NetworkManager.shared.downloadImageWithPath(path: "Profile/\(user.uid)") { image in
            cell.profileImage.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell: UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
        
        if selectedUsers.contains(indexPath) {
            selectedUsers.remove(at: selectedUsers.firstIndex(of: indexPath)!)
            selectedCell.backgroundColor = ColorConstants.customWhite
        } else {
            selectedUsers.append(indexPath)
            selectedCell.backgroundColor = ColorConstants.dimTealGreen
        }
    }
}

extension CreateGroupChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension CreateGroupChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            groupPhoto.image = imageSelected
            groupPhoto.layer.borderColor = ColorConstants.tealGreen.cgColor
            groupPhoto.contentMode = .scaleAspectFill
        }
        
        dismiss(animated: true, completion: nil)
    }
}
