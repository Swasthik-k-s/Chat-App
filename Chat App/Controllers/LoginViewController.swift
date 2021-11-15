//
//  ViewController.swift
//  Chat App
//
//  Created by Swasthik K S on 12/11/21.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNotificationObserver()
        configureUI()
        
    }
    
    let appImage = CustomImageView(image: ImageConstants.appIcon!, height: 100, width: 100, cornerRadius: 0, color: ColorConstants.tealGreen)
    let appLabel = CustomLabel(text: "Welcome to Chat App", color: ColorConstants.tealGreen, font: FontConstants.bold3)
    
    let bottomText = CustomLabel(text: "Don't have an Account?", color: ColorConstants.tealGreen, font: FontConstants.normal1)
    let signUpButton = CustomButton(title: "Sign Up", color: .clear, textColor: ColorConstants.darkTealGreen, font: FontConstants.bold2, cornerRadius: 0)
    
    let signUp: UIButton = {
        let button = UIButton()
        button.attributedTitle(firstPart: "Don't have an Account?", secondPart: "Sign Up")
        return button
    }()
//    let appTopView = LoginTopContainerView()
    
    let emailText = CustomTextField(placeholder: "Email Address", color: ColorConstants.tealGreen)
    let passwordText = CustomTextField(placeholder: "Password", color: ColorConstants.tealGreen)
    
//    addSubview(textField)
    lazy var emailField = InputFieldView(image: ImageConstants.mail!, color: ColorConstants.tealGreen, textField: emailText)
    lazy var passwordField = InputFieldView(image: ImageConstants.mail!, color: ColorConstants.tealGreen, textField: passwordText)
    
    let loginButton = CustomButton(title: "Login", color: ColorConstants.darkTealGreen, textColor: .white, font: FontConstants.bold1, cornerRadius: 25)
    
    @objc func navigateSignUp() {
        let signUpVC = SignUpViewController()
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true, completion: nil)
    }
    
    func configureNotificationObserver() {
        emailText.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordText.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailText {
            emailField.layer.borderWidth = (emailText.text?.isEmpty)! ? 0 : 1
        }
    }

    func configureUI() {
        
        passwordText.isSecureTextEntry = true
        signUp.addTarget(self, action: #selector(navigateSignUp), for: .touchUpInside)
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let topStack = UIStackView(arrangedSubviews: [appImage, appLabel])
        topStack.spacing = 10
        topStack.axis = .vertical
        topStack.alignment = .center
        
        let inputFieldStack = UIStackView(arrangedSubviews: [emailField, passwordField, loginButton])
        inputFieldStack.axis = .vertical
        inputFieldStack.spacing = 20
//        inputFields.distribution = .fill
//        inputFieldStack.backgroundColor = .red
        
        let bottomStack = UIStackView(arrangedSubviews: [signUp])
        bottomStack.axis = .horizontal
        bottomStack.spacing = 5
        bottomStack.distribution = .fill
//        bottomStack.alignment = .center

        view.addSubview(topStack)
        view.addSubview(inputFieldStack)
        view.addSubview(bottomStack)
        
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

