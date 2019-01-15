//
//  RegistrationViewController.swift
//  InYerevan
//
//  Created by Vahram Tadevosian on 1/13/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var additionalButtons: [UIButton]!
    private var isSigningUp: Bool = false
    private var isResettingPassword: Bool = false
    
    @IBAction func signUpAction(_ sender: UIButton) {
        clean()
        isSigningUp = !isSigningUp
        additionalButtons[0].isHidden = false
        confirmPasswordTextField.isHidden = !isSigningUp
        passwordTextField.isHidden = false
        isResettingPassword = false
        let senderTitle = isSigningUp ? "Sign In" : "Create Account"
        let loginButtonTitle = isSigningUp ? "SIGN UP" : "LOG IN"
        sender.setTitle(senderTitle, for: .normal)
        loginButton.setTitle(loginButtonTitle, for: .normal)
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        clean()
        isResettingPassword = !isResettingPassword
        passwordTextField.isHidden = isResettingPassword
        confirmPasswordTextField.isHidden = isResettingPassword
        sender.isHidden = isResettingPassword
        isSigningUp = true
        additionalButtons[1].setTitle("Create Account", for: .normal)
        loginButton.setTitle("RESET PASSWORD", for: .normal)
        
    }
    
    @IBAction func loginAction() {
        if isResettingPassword {
            resetPassword()
        } else if isSigningUp {
            signUp()
        } else {
            signIn()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view!.addSubview(backgroundImageView)
        view!.addSubview(stackView)
        customizeSubviews()
        becomeTextFieldDelegates() 
    }
    
    private func customizeSubviews() {
        let trailingConstant = backgroundImageView.bounds.width - (0.18 * backgroundImageView.bounds.width)
        backgroundImageView.addConstraints(equalToConstraintsOf: view, withTrailingConstant: trailingConstant,
                                           leadingConstant: 0, bottomConstant: 0, topConstant: 0)
        stackView.addConstraints(equalToConstraintsOf: view, withHeightMultiplier: 0.25,
                                 widthMultiplier: 0.45, centerXMultiplier: 1, centerYMultiplier: 0.8)
        let height = view.bounds.height
        stackView.spacing = height / 110
        emailTextField.customize(by: view, placeholder: "Email")
        passwordTextField.customize(by: view, placeholder: "Password")
        confirmPasswordTextField.customize(by: view, placeholder: "Repeat password")
        loginButton.customize(by: view, shouldBeRound: true)
        additionalButtons.forEach({ button in
            button.customize(by: view, shouldBeRound: false)
        })
    }
    
    private func becomeTextFieldDelegates() {
        passwordTextField.delegate = self
        emailTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    private func login(with email: String) {
        User.isAdministration = User.administration.contains(email)
        User.email = email
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController")
        self.show(vc, sender: nil)
        
    }
    
    private func signIn() {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
            if let firebaseError = error {
                self.errorLabel.text = firebaseError.localizedDescription
                return
            }
            self.login(with: self.emailTextField.text!)
        })
    }
    
    private func signUp() {
        if passwordTextField.text == confirmPasswordTextField.text {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
                if let firebaseError = error {
                    self.errorLabel.text = firebaseError.localizedDescription
                    return
                }
                
                self.login(with: self.emailTextField.text!)
            })
        } else {
            errorLabel.text = "Passwords do not match."
        }
    }
    
    private func resetPassword() {
        //
    }
    
    private func clean() {
        emailTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
        errorLabel.text = ""
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isResettingPassword {
            resetPassword()
        } else {
            if textField == emailTextField {
                if passwordTextField.text!.isEmpty {
                    passwordTextField.becomeFirstResponder()
                } else {
                    if isSigningUp {
                        if confirmPasswordTextField.text!.isEmpty {
                            confirmPasswordTextField.becomeFirstResponder()
                        } else {
                            signUp()
                        }
                    } else {
                        signIn()
                    }
                }
            } else if textField == passwordTextField {
                if emailTextField.text!.isEmpty {
                    emailTextField.becomeFirstResponder()
                } else {
                    if isSigningUp {
                        if confirmPasswordTextField.text!.isEmpty {
                            confirmPasswordTextField.becomeFirstResponder()
                        } else {
                            signUp()
                        }
                    } else {
                        signIn()
                    }
                }
            }else if textField == confirmPasswordTextField {
                if emailTextField.text!.isEmpty {
                    emailTextField.becomeFirstResponder()
                } else if passwordTextField.text!.isEmpty {
                    passwordTextField.becomeFirstResponder()
                } else {
                    signUp()
                }
            }
        }
        return true
    }
}