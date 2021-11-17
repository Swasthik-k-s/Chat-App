//
//  HomeViewController.swift
//  Chat App
//
//  Created by Swasthik K S on 15/11/21.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate {
    
    let cellIdentifier = "chatCell"
    
    var chats: [ChatItem] = []
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        checkUserLogin()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        checkUserLogin()
    }
    
    let profileButton = CustomButton(title: "Profile", color: .white, textColor: ColorConstants.tealGreen, font: FontConstants.bold1, cornerRadius: 0)
    let logoutButton = CustomButton(title: "Logout", color: .white, textColor: ColorConstants.tealGreen, font: FontConstants.bold1, cornerRadius: 0)
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageConstants.add, for: .normal)
        button.backgroundColor = ColorConstants.tealGreen
        button.tintColor = ColorConstants.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 30
        
        return button
    }()
    
    lazy var menuStack = UIStackView(arrangedSubviews: [profileButton, logoutButton])
    lazy var menuView = UIView()
    
    func checkUserLogin() {
        if NetworkManager.shared.getUID() == nil {
            presentLoginScreen()
        } else {
            configureCollectionView()
            fetchUserData()
            configureUI()
            configureNavigationBar()
            configureSideMenu()
        }
    }
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let loginVC = LoginViewController()
            loginVC.delegate = self
            
            let navigation = UINavigationController(rootViewController: loginVC)
            navigation.setNavigationBarHidden(true, animated: true)
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
    func fetchUserData() {
        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "dd/MM/YY hh:mm:a"
        dateFormatter.dateFormat = "hh:mm:a"
        
//        chats = []
        let chat1 = ChatItem.init(name: "Rahul", message: "Good Morning", time: dateFormatter.string(from: Date()))
        let chat2 = ChatItem.init(name: "Gautham", message: "Hello", time: dateFormatter.string(from: Date()))
        let chat3 = ChatItem.init(name: "Manoj", message: "Thank You", time: dateFormatter.string(from: Date()))
        let chat4 = ChatItem.init(name: "Amogh", message: "ok", time: dateFormatter.string(from: Date()))
        let chat5 = ChatItem.init(name: "Rakesh", message: "bye", time: dateFormatter.string(from: Date()))
        
        let chat6 = ChatItem.init(name: "Rahul", message: "Good Morning", time: dateFormatter.string(from: Date()))
        let chat7 = ChatItem.init(name: "Gautham", message: "Hello", time: dateFormatter.string(from: Date()))
        let chat8 = ChatItem.init(name: "Manoj", message: "Thank You", time: dateFormatter.string(from: Date()))
        let chat9 = ChatItem.init(name: "Amogh", message: "ok", time: dateFormatter.string(from: Date()))
        let chat10 = ChatItem.init(name: "Rakesh", message: "bye", time: dateFormatter.string(from: Date()))
        
        chats.append(chat1)
        chats.append(chat2)
        chats.append(chat3)
        chats.append(chat4)
        chats.append(chat5)
        chats.append(chat6)
        chats.append(chat7)
        chats.append(chat8)
        chats.append(chat9)
        chats.append(chat10)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        NetworkManager.shared.fetchUser(uid: NetworkManager.shared.getUID()!) { user in
            print(user)
        }
    }
    
    func configureUI() {
        navigationItem.backButtonTitle = ""
        navigationItem.title = "Chat App"
        //        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let menu = UIBarButtonItem(image: ImageConstants.menu, style: .plain, target: self, action: #selector(handleMenu))
//        let add = UIBarButtonItem(image: ImageConstants.add, style: .plain, target: self, action: #selector(handleAdd))
        
        navigationItem.rightBarButtonItems = [menu]
//        navigationItem.leftBarButtonItems = [add]
        
        view.addSubview(addButton)
        view.bringSubviewToFront(addButton)
        addButton.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.widthAnchor.constraint(equalToConstant: 60),
            addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
        print("Home Screen")
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func configureSideMenu() {
        
        let width = view.frame.width / 2
        
        profileButton.addTarget(self, action: #selector(navigateProfileVC), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        menuView.addSubview(menuStack)
        view.addSubview(menuView)
        menuStack.spacing = 5
        menuStack.axis = .vertical
        menuStack.distribution = .fillEqually
        menuStack.alignment = .leading
        menuView.backgroundColor = .white
        
        menuView.layer.shadowColor = ColorConstants.darkTealGreen.cgColor
        menuView.layer.shadowRadius = 15
        menuView.layer.shadowOpacity = 0.9
        menuView.layer.shadowOffset.height = 5
        menuView.layer.cornerRadius = 10
        
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            menuStack.leftAnchor.constraint(equalTo: menuView.leftAnchor, constant: 10),
            menuStack.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 10),
            menuStack.rightAnchor.constraint(equalTo: menuView.rightAnchor),
            
            menuView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: width),
            menuView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuView.rightAnchor.constraint(equalTo: view.rightAnchor),
            menuView.heightAnchor.constraint(equalTo: menuStack.heightAnchor, constant: 20),
            
        ])
        
        menuView.isHidden = true
        
    }
    
    @objc func handleMenu() {
        
        menuView.isHidden = !menuView.isHidden
        
        if menuView.isHidden {
            view.sendSubviewToBack(menuView)
        } else {
            view.bringSubviewToFront(menuView)
        }
    }
    
    @objc func handleAdd() {
        let addVC = AddChatViewController()
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    @objc func navigateProfileVC() {
        menuView.isHidden = !menuView.isHidden
        
        let profile = ProfileViewController()
        navigationController?.pushViewController(profile, animated: true)
    }
    
    @objc func handleLogout() {
        menuView.isHidden = !menuView.isHidden
        let logout = {
            let isSignedOut = NetworkManager.shared.signout()
            
            if isSignedOut {
                self.presentLoginScreen()
            }
        }
        
        showAlertWithCancel(title: "Logout", message: "Are you Sure", buttonText: "Logout", buttonAction: logout)
    }
}

extension HomeViewController: UserAuthenticatedDelegate {
    func userAuthenticated() {
        fetchUserData()
        configureUI()
        configureNavigationBar()
        configureCollectionView()
        configureSideMenu()
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("5")
        return chats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ChatCell
        
        let chat = chats[indexPath.row]
        
        cell.nameLabel.text = chat.name
        cell.messageLabel.text = chat.message
        cell.dateLabel.text = chat.time
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
        let chatVC = ChatViewController()
        chatVC.chat = chats[indexPath.row]
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
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