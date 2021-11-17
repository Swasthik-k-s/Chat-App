//
//  AddChatViewController.swift
//  Chat App
//
//  Created by Swasthik K S on 17/11/21.
//

import UIKit

class AddChatViewController: UIViewController, UICollectionViewDelegate {

    let cellIdentifier = "userCell"
    
    var users: [UserData] = []
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
        configureUI()
        fetchAllUser()
        
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Select User"
        navigationItem.backButtonTitle = ""
        
        let search = UIBarButtonItem(image: ImageConstants.search, style: .plain, target: self, action: #selector(handleSearch))
        
        navigationItem.rightBarButtonItems = [search]
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func fetchAllUser() {
        let user1 = UserData(username: "Suresh", email: "suresh@gmail.com", profileURL: "abc", uid: "asjhbddcd")
        
        users.append(user1)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    @objc func handleSearch() {
        
    }
}

extension AddChatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ChatCell
        
        let user = users[indexPath.row]
        
        cell.nameLabel.text = user.email
        cell.messageLabel.text = user.username
        cell.dateLabel.isHidden = true
//        let chat = chats[indexPath.row]
//
//        cell.nameLabel.text = chat.name
//        cell.messageLabel.text = chat.message
//        cell.dateLabel.text = chat.time
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/YY hh:mm:a"
//        dateFormatter.dateFormat = "hh:mm:a"
//
//        cell.nameLabel.text = "Name"
//        cell.messageLabel.text = "Message"
//        cell.profileImage.image = UIImage(systemName: "person.fill")
//        cell.dateLabel.text = dateFormatter.string(from: Date())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension AddChatViewController: UICollectionViewDelegateFlowLayout {
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
