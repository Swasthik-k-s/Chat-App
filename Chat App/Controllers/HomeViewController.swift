//
//  HomeViewController.swift
//  Chat App
//
//  Created by Swasthik K S on 15/11/21.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate {
    
    let cellIdentifier = "chatCell"
    
    var chats: [Chats] = []
    var currentUser: UserData?
    var collectionView: UICollectionView!
    var editMode = false
    var initialFetch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = ColorConstants.viewBackground
        checkUserLogin()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addButton.isEnabled = true
    }
    
    let profileButton = CustomButton(title: "Profile", color: .clear, textColor: ColorConstants.titleText, font: FontConstants.bold1, cornerRadius: 0)
    let logoutButton = CustomButton(title: "Logout", color: .clear, textColor: ColorConstants.titleText, font: FontConstants.bold1, cornerRadius: 0)
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageConstants.add, for: .normal)
        button.backgroundColor = ColorConstants.lightGreen
        button.tintColor = ColorConstants.icon
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
            
            let navigation = CustomNavigationController(rootViewController: loginVC)
//            let navigation = UINavigationController(rootViewController: loginVC)
            navigation.setNavigationBarHidden(true, animated: true)
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
    func fetchUserData() {
        chats = []
        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "dd/MM/YY hh:mm:a"
        dateFormatter.dateFormat = "hh:mm:a"
        
        NetworkManager.shared.fetchUser() { currentUser in
            self.currentUser = currentUser
        }
        NetworkManager.shared.fetchChats(uid: NetworkManager.shared.getUID()!) { chats in
            self.chats = chats
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func configureUI() {
        navigationItem.backButtonTitle = ""
        navigationItem.title = "Chat App"
        
        let menu = UIBarButtonItem(image: ImageConstants.menu, style: .plain, target: self, action: #selector(handleMenu))
        
        navigationItem.rightBarButtonItems = [menu]
        
//        let edit = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEdit))
        
//        navigationItem.leftBarButtonItems = [edit]
        
        view.addSubview(addButton)
        view.bringSubviewToFront(addButton)
        addButton.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.widthAnchor.constraint(equalToConstant: 60),
            addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = ColorConstants.viewBackground
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
        menuView.backgroundColor = ColorConstants.popupView
        
//        menuView.layer.shadowColor = ColorConstants.darkTealGreen.cgColor
//        menuView.layer.shadowRadius = 15
//        menuView.layer.shadowOpacity = 0.9
//        menuView.layer.shadowOffset.height = 5
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
    
//    @objc func handleEdit() {
//        editMode = !editMode
//        initialFetch  = true
//        collectionView.reloadData()
//        
//    }
    
    @objc func handleAdd() {
        addButton.pulseEffect()
        addButton.isEnabled = false
        let delayTime = DispatchTime.now() + 1.5
        DispatchQueue.main.asyncAfter(deadline: delayTime) { [self] in
            let addVC = AddChatViewController()
            addVC.currentUser = currentUser
            addVC.chats = chats
            navigationController?.pushViewController(addVC, animated: true)
        }
       
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
    
    @objc func handleSelect() {
        print("Select")
    }
}

extension HomeViewController: UserAuthenticatedDelegate {
    func userAuthenticated() {
        configureCollectionView()
        fetchUserData()
        configureUI()
        configureNavigationBar()
        configureSideMenu()
    }
}

extension HomeViewController: ChatSelectedDelegate {
    func chatSelected(isSelected: Bool) {
        print("Selected\(isSelected)")
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! UserCell
        
        cell.profileImage.image = ImageConstants.person
        let chat = chats[indexPath.row]
        cell.chat = chat
        cell.backgroundColor = ColorConstants.viewBackground
//        cell.animateView(open: editMode)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chatVC = ChatViewController()
        chatVC.chat = chats[indexPath.row]
        view.sendSubviewToBack(menuView)
        menuView.isHidden = true
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
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
