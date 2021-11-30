//
//  SignUpViewController.swift
//  Chat App
//
//  Created by Swasthik K S on 12/11/21.
//

import UIKit

class SignUpViewController: UIViewController {
    
    var delegate: UserAuthenticatedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureUI()
        configureNotificationObserver()
        
    }
    
    let profileImage = CustomImageView(image: ImageConstants.person!, height: 100, width: 100, cornerRadius: 50, color: ColorConstants.tealGreen)
    let appLabel = CustomLabel(text: "Welcome to Chat App", color: ColorConstants.tealGreen, font: FontConstants.bold3)
    
    let bottomText = CustomLabel(text: "Already have an Account?", color: ColorConstants.tealGreen, font: FontConstants.normal1)
    let loginButton = CustomButton(title: "Login", color: .clear, textColor: ColorConstants.darkTealGreen, font: FontConstants.bold2, cornerRadius: 0)
    
    let usernameTextField = CustomTextField(placeholder: "User Name", color: ColorConstants.tealGreen)
    let emailTextField = CustomTextField(placeholder: "Email Address", color: ColorConstants.tealGreen)
    let passwordTextField = CustomTextField(placeholder: "Password", color: ColorConstants.tealGreen)
    
    lazy var usernameContainer: InputFieldView = {
        usernameTextField.keyboardType = .default
        return InputFieldView(image: ImageConstants.person!, color: ColorConstants.tealGreen, textField: usernameTextField)
    }()
    
    lazy var emailContainer: InputFieldView = {
        emailTextField.keyboardType = .emailAddress
        return InputFieldView(image: ImageConstants.mail!, color: ColorConstants.tealGreen, textField: emailTextField)
    }()
    
    lazy var passwordContainer: InputFieldView = {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.keyboardType = .default
        return InputFieldView(image: ImageConstants.password!, color: ColorConstants.tealGreen, textField: passwordTextField)
    }()
    
    let signUpButton = CustomButton(title: "Sign Up", color: ColorConstants.darkTealGreen, textColor: .white, font: FontConstants.bold1, cornerRadius: 25)
    
    @objc func navigateLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp() {
        guard let profilePic = profileImage.image else { return }
        guard let username = usernameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        let fieldError = validateSignUp(profilePic: profilePic, username: username, email: email, password: password)
        
        if fieldError != nil {
            showAlert(title: "Invalid", message: fieldError!)
        } else {
            
            NetworkManager.shared.signup(withEmail: email, password: password) { [weak self] result, error in
                guard let self = self else { return }
                
                if error != nil {
                    self.showAlert(title: "Failed", message: error!.localizedDescription)
                    return
                }
                
                if let result = result {
                    let uid = result.user.uid
                    
                    ImageUploader.uploadImage(image: profilePic, name: uid) { url in
//                        let newUser = UserData()
//                        newUser.email = email
//                        newUser.username = username
//                        newUser.uid = uid
//                        newUser.profileURL = url
                        let newUser = UserData(username: username, email: email, profileURL: url, uid: uid)
                        NetworkManager.shared.addUser(user: newUser)
                        self.delegate?.userAuthenticated()
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    func configureNotificationObserver() {
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == usernameTextField {
            usernameContainer.layer.borderColor = usernameValidation(username: usernameTextField.text!) ? ColorConstants.tealGreen.cgColor : ColorConstants.customRed.cgColor
        }
        
        if sender == emailTextField {
            emailContainer.layer.borderColor = emailValidation(email: emailTextField.text!) ? ColorConstants.tealGreen.cgColor : ColorConstants.customRed.cgColor
        }
        
        if sender == passwordTextField {
            passwordContainer.layer.borderColor = passwordValidation(password: passwordTextField.text!) ? ColorConstants.tealGreen.cgColor : ColorConstants.customRed.cgColor
        }
    }
    
    @objc func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func validateSignUp(profilePic: UIImage, username: String, email: String, password: String) -> String? {
        if username == "" || email == "" || password == "" {
            return "Please fill all the Fields"
        }
        
        if profilePic == ImageConstants.person {
            return MessageConstants.profilePictureInvalid
        }
        
        if !usernameValidation(username: username) {
            return MessageConstants.usernameInvalid
        }
        
        if !emailValidation(email: email) {
            return MessageConstants.emailInvalid
        }
        
        if !passwordValidation(password: password) {
            return MessageConstants.passwordInvalid
        }
        
        return nil
    }
    
    func configureUI() {
        
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = ColorConstants.customRed.cgColor
        profileImage.clipsToBounds = true
        profileImage.isUserInteractionEnabled = true
        profileImage.contentMode = .scaleAspectFill
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentImagePicker))
        profileImage.addGestureRecognizer(tapGesture)
        
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.addTarget(self, action: #selector(navigateLogin), for: .touchUpInside)
        
        let topStack = UIStackView(arrangedSubviews: [appLabel, profileImage])
        topStack.spacing = 30
        topStack.axis = .vertical
        topStack.alignment = .center
        
        let inputFieldStack = UIStackView(arrangedSubviews: [usernameContainer, emailContainer, passwordContainer, signUpButton])
        inputFieldStack.axis = .vertical
        inputFieldStack.spacing = 20
        
        let bottomStack = UIStackView(arrangedSubviews: [bottomText, loginButton])
        bottomStack.axis = .horizontal
        bottomStack.spacing = 5
        bottomStack.distribution = .equalCentering
        bottomStack.alignment = .center
        
        view.addSubview(topStack)
        view.addSubview(bottomStack)
        view.addSubview(inputFieldStack)
        
        topStack.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        inputFieldStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            topStack.leftAnchor.constraint(equalTo: view.leftAnchor),
            topStack.rightAnchor.constraint(equalTo: view.rightAnchor),
            topStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            bottomStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            inputFieldStack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            inputFieldStack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            inputFieldStack.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 20),
            
        ])
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImage.image = imageSelected
            profileImage.layer.borderColor = ColorConstants.tealGreen.cgColor
        }
        
        dismiss(animated: true, completion: nil)
    }
}
