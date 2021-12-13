//
//  ProfileViewController.swift
//  Chat App
//
//  Created by Swasthik K S on 16/11/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
//    let userid = NetworkManager.shared.getUID()!
    var currentUser: UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureUI()
        fetchUserData()
    }
    
    let profileImage = CustomImageView(image: ImageConstants.person!, height: 100, width: 100, cornerRadius: 50, color: ColorConstants.green)
    
    let username = CustomLabel(text: "", color: ColorConstants.green, font: FontConstants.bold1)
    let email = CustomLabel(text: "", color: ColorConstants.green, font: FontConstants.bold1)
    let resetButton = CustomButton(title: "Reset Password", color: ColorConstants.green, textColor: ColorConstants.icon, font: FontConstants.bold1, cornerRadius: 10)
    
    func configureUI() {
        view.backgroundColor = ColorConstants.viewBackground
        navigationItem.title = "Profile"
        navigationItem.backButtonTitle = ""
        
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = ColorConstants.green.cgColor
        profileImage.clipsToBounds = true
        profileImage.isUserInteractionEnabled = true
        profileImage.contentMode = .scaleAspectFill
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentImagePicker))
        resetButton.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        
        profileImage.addGestureRecognizer(tapGesture)
        
        let userDataStack = UIStackView(arrangedSubviews: [username, email])
        userDataStack.axis = .vertical
        userDataStack.spacing = 20
        
        view.addSubview(profileImage)
        view.addSubview(userDataStack)
        view.addSubview(resetButton)
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        userDataStack.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //            profileImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            
            userDataStack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            userDataStack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            userDataStack.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            
            resetButton.topAnchor.constraint(equalTo: userDataStack.bottomAnchor, constant: 20),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func fetchUserData() {
        print("Fetching")
        NetworkManager.shared.fetchUser() { user in
            self.username.text = "Username: \(user.username)"
            self.email.text = "Email: \(user.email)"
            
            self.currentUser = user
            
            let path = "Profile/\(user.uid)"
            NetworkManager.shared.downloadImageWithPath(path: path) { image in
                DispatchQueue.main.async {
                    self.profileImage.image = image
                }
            }
        }
    }
    
    @objc func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc func handleReset() {
        NetworkManager.shared.resetPassword(email: currentUser!.email) { result in
            if result == "Sent" {
                self.showAlert(title: "Password Reset Email Sent", message: "A Password Reset link has been sent to your Email")
//                let isSignOut = NetworkManager.shared.signout()
//                if isSignOut {
//                    HomeViewController().presentLoginScreen()
//                }
//
            } else {
                self.showAlert(title: "Failed", message: "Error while reseting the Password. Try Again Later")
            }
        }
    }
    
    func uploadNewProfile(image: UIImage) {
        guard let uid = NetworkManager.shared.getUID() else { return }
        let path = "Profile/\(uid)"
        
        ImageUploader.uploadImage(image: image, name: path) { url in
            self.currentUser?.profileURL = url
            
            NetworkManager.shared.addUser(user: self.currentUser!)
            print("New URL\(url)")
            
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImage.image = imageSelected
            profileImage.layer.borderColor = ColorConstants.green.cgColor
            uploadNewProfile(image: imageSelected)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
