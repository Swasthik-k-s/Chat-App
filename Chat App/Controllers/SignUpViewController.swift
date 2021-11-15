//
//  SignUpViewController.swift
//  Chat App
//
//  Created by Swasthik K S on 12/11/21.
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureUI()

    }
    
//    let appTopView = LoginTopContainerView()
    let appImage = CustomImageView(image: ImageConstants.appIcon!, height: 100, width: 100, cornerRadius: 0, color: ColorConstants.tealGreen)
    let appLabel = CustomLabel(text: "Welcome to Chat App", color: ColorConstants.tealGreen, font: FontConstants.bold3)
    
    let bottomText = CustomLabel(text: "Already have an Account?", color: ColorConstants.tealGreen, font: FontConstants.normal1)
    let loginButton = CustomButton(title: "Login", color: .clear, textColor: ColorConstants.darkTealGreen, font: FontConstants.bold2, cornerRadius: 0)
    
    let firstNameText = CustomTextField(placeholder: "First Name", color: ColorConstants.tealGreen)
    let lastNameText = CustomTextField(placeholder: "Last Name", color: ColorConstants.tealGreen)
    let emailText = CustomTextField(placeholder: "Email Address", color: ColorConstants.tealGreen)
    let passwordText = CustomTextField(placeholder: "Password", color: ColorConstants.tealGreen)
    
    lazy var firstNameField = InputFieldView(image: ImageConstants.person!, color: ColorConstants.tealGreen, textField: firstNameText)
    lazy var lastNameField = InputFieldView(image: ImageConstants.person!, color: ColorConstants.tealGreen, textField: lastNameText)
    lazy var emailField = InputFieldView(image: ImageConstants.mail!, color: ColorConstants.tealGreen, textField: emailText)
    lazy var passwordField = InputFieldView(image: ImageConstants.mail!, color: ColorConstants.tealGreen, textField: passwordText)
    
    let signUpButton = CustomButton(title: "Sign Up", color: ColorConstants.darkTealGreen, textColor: .white, font: FontConstants.bold1, cornerRadius: 25)
    
    @objc func navigateLogin() {
//        let loginVC = LoginViewController()
//        loginVC.modalPresentationStyle = .fullScreen
//        present(loginVC, animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func configureUI() {
        
        passwordText.isSecureTextEntry = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.addTarget(self, action: #selector(navigateLogin), for: .touchUpInside)
        
        let topStack = UIStackView(arrangedSubviews: [appImage, appLabel])
        topStack.spacing = 10
        topStack.axis = .vertical
        topStack.alignment = .center
        
        let inputFieldStack = UIStackView(arrangedSubviews: [firstNameField, lastNameField, emailField, passwordField, signUpButton])
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
            inputFieldStack.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 30),
            
        ])
    }
}
