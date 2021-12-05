//
//  ViewController.swift
//  Chat App
//
//  Created by Swasthik K S on 12/11/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    var delegate: UserAuthenticatedDelegate?
    
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
    
    let forgotPasswordButton = CustomButton(title: "Forgot Password", color: .clear, textColor: ColorConstants.darkTealGreen, font: FontConstants.bold1, cornerRadius: 0)
    
    let emailTextField = CustomTextField(placeholder: "Email Address", color: ColorConstants.tealGreen)
    let passwordTextField = CustomTextField(placeholder: "Password", color: ColorConstants.tealGreen)
    
    lazy var emailContainer: InputFieldView = {
        emailTextField.keyboardType = .emailAddress
        return InputFieldView(image: ImageConstants.mail!, color: ColorConstants.tealGreen, textField: emailTextField)
    }()
    
    lazy var passwordContainer: InputFieldView = {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.keyboardType = .default
        return InputFieldView(image: ImageConstants.password!, color: ColorConstants.tealGreen, textField: passwordTextField)
    }()
    
    let loginButton = CustomButton(title: "Login", color: ColorConstants.darkTealGreen, textColor: .white, font: FontConstants.bold1, cornerRadius: 25)
    
    let scrollView = UIScrollView()
    
    @objc func navigateSignUp() {
        let signUpVC = SignUpViewController()
        signUpVC.delegate = delegate
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        let fieldError = validateLogin(email: email, password: password)
        
        if fieldError != nil {
            showAlert(title: "Invalid", message: fieldError!)
        } else {
            NetworkManager.shared.login(withEmail: email, password: password) { [weak self] result, error in
                guard let self = self else { return }
                
                if error != nil {
                    self.showAlert(title: "Failed", message: error!.localizedDescription)
                } else {
                    self.delegate?.userAuthenticated()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func handleForgotPassword() {
        guard let email = emailTextField.text else { return }
        if emailValidation(email: email) {
            NetworkManager.shared.resetPassword(email: email) { result in
                if result == "Sent" {
                    self.showAlert(title: "Password Reset Email Sent", message: "A Password Reset link has been sent to your Email")
                } else {
                    self.showAlert(title: "Failed", message: "Error while reseting the Password. Try Again Later")
                }
            }
        } else {
            showAlert(title: "Please Enter Valid Email", message: MessageConstants.emailInvalid)
        }
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            emailContainer.layer.borderColor = emailValidation(email: emailTextField.text!) ? ColorConstants.tealGreen.cgColor : ColorConstants.customRed.cgColor
        }
        if sender == passwordTextField {
            passwordContainer.layer.borderColor = passwordValidation(password: passwordTextField.text!) ? ColorConstants.tealGreen.cgColor : ColorConstants.customRed.cgColor
        }
    }
    
    func configureNotificationObserver() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func handleOrientationChange() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: 600)
    }
    
    func validateLogin(email: String, password: String) -> String? {
        if email == "" || password == "" {
            return email == "" ? "Please Enter Email" : "Please Enter Password"
        }
        if !emailValidation(email: email) || !passwordValidation(password: password) {
            return emailValidation(email: email) ? MessageConstants.passwordInvalid : MessageConstants.emailInvalid
        }
        return nil
    }
    
    func configureUI() {
        
        signUpButton.addTarget(self, action: #selector(navigateSignUp), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let topStack = UIStackView(arrangedSubviews: [appImage, appLabel])
        topStack.spacing = 10
        topStack.axis = .vertical
        topStack.alignment = .center
        
        let inputFieldStack = UIStackView(arrangedSubviews: [emailContainer, passwordContainer, loginButton])
        inputFieldStack.axis = .vertical
        inputFieldStack.spacing = 20
        
        let bottomStack = UIStackView(arrangedSubviews: [bottomText, signUpButton])
        bottomStack.axis = .horizontal
        bottomStack.spacing = 5
        bottomStack.distribution = .fill
        
        view.addSubview(scrollView)
        scrollView.addSubview(topStack)
        scrollView.addSubview(inputFieldStack)
        scrollView.addSubview(bottomStack)
        scrollView.addSubview(forgotPasswordButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        topStack.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        inputFieldStack.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            topStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            topStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            
            inputFieldStack.leftAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leftAnchor, constant: 20),
            inputFieldStack.rightAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.rightAnchor, constant: -20),
            inputFieldStack.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 30),
            
            forgotPasswordButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            forgotPasswordButton.topAnchor.constraint(equalTo: inputFieldStack.bottomAnchor, constant: 10),
            
            bottomStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            bottomStack.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 10),
            
        ])
        scrollView.contentSize = CGSize(width: view.frame.width, height: 600)
    }
}

