//
//  AddChatViewController.swift
//  Chat App
//
//  Created by Swasthik K S on 17/11/21.
//

import UIKit

class AddChatViewController: UIViewController, UICollectionViewDelegate {
    
    let cellIdentifier = "userCell"
    
    var chats: [Chats] = []
    var users: [UserData] = []
    var currentUser: UserData?
    var collectionView: UICollectionView!
    
    var searchUsers: [UserData] = []
    let searchController = UISearchController(searchResultsController: nil)
    private var inSearchMode: Bool {
        return !searchController.searchBar.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
        configureUI()
        configureSearch()
        fetchAllUser()
        
    }
    
    let groupChatButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Group Chat", for: .normal)
        button.backgroundColor = ColorConstants.lightGreen
        button.tintColor = ColorConstants.icon
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(handleGroupChat), for: .touchUpInside)
        button.titleLabel?.font = FontConstants.bold1
        return button
    }()
    
    func configureUI() {
        
        navigationItem.title = "Select User"
        navigationItem.backButtonTitle = ""
        
        view.addSubview(groupChatButton)
        view.bringSubviewToFront(groupChatButton)
        
        NSLayoutConstraint.activate([
            groupChatButton.heightAnchor.constraint(equalToConstant: 50),
            groupChatButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            groupChatButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            groupChatButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }
    
    @objc func handleGroupChat() {
        let vc = CreateGroupChatViewController()
        vc.currentUser = currentUser
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = ColorConstants.viewBackground
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func configureSearch() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.tintColor = .white
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search Users"
    }
    
    func fetchAllUser() {
        NetworkManager.shared.fetchAllUsers() { users in
            self.users = users
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func handleSearch() {
        
    }
}

extension AddChatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? searchUsers.count : users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! UserCell
        
        let user = inSearchMode ? searchUsers[indexPath.row] : users[indexPath.row]
        cell.profileImage.image = ImageConstants.person
        cell.nameLabel.text = user.email
        cell.messageLabel.text = user.username
        cell.dateLabel.isHidden = true
        cell.backgroundColor = ColorConstants.viewBackground
//        cell.selectButton.isHidden = true
        
        let uid = user.uid
        
        NetworkManager.shared.downloadImageWithPath(path: "Profile/\(uid)") { image in
            cell.profileImage.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        let users: [UserData] = [currentUser!, selectedUser]
        
        let id = "\(currentUser!.uid)_\(selectedUser.uid)"
        let chatVC = ChatViewController()
        var vcArray = navigationController?.viewControllers
        vcArray?.removeLast()
        
        for chat in chats {
            if chat.isGroupChat { continue }
            var currentChat = chat
            let uid1 = chat.users[0].uid
            let uid2 = chat.users[1].uid
            
            if uid1 == currentUser!.uid && uid2 == selectedUser.uid || uid1 == selectedUser.uid && uid2 == currentUser!.uid {
                print("Already Chated")
                
                currentChat.otherUser =  uid1 == currentUser!.uid ? 1 : 0
                chatVC.chat = currentChat
                
                vcArray?.append(chatVC)
                navigationController?.setViewControllers(vcArray!, animated: true)
                return
            }
            
        }
        print("New Chat")
        NetworkManager.shared.addChat(users: [currentUser!, selectedUser], id: id, isGroupChat: false, groupName: "", groupIconPath: "")
        
        chatVC.chat = Chats(chatId: id, users: users, lastMessage: nil, messages: [], otherUser: 1, isGroupChat: false)
        
        vcArray?.append(chatVC)
        navigationController?.setViewControllers(vcArray!, animated: true)
    }
}

extension AddChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension AddChatViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        
        if inSearchMode {
            searchUsers.removeAll()
            
            for user in users {
                if user.username.lowercased().contains(searchText.lowercased()) || user.email.lowercased().contains(searchText.lowercased()) {
                    searchUsers.append(user)
                }
            }
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

