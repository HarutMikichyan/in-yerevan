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
    
    // MARK:- INTERFACE BUILDER OUTLETS

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var additionalButtons: [UIButton]!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
  
    // MARK:- OTHER PROPERTIES
  
    private var isSigningUp: Bool = false
    private var isResettingPassword: Bool = false
    
    // MARK:- ACTIONS

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
        additionalButtons[1].setTitle("Log In", for: .normal)
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
    
  @IBAction func resetPasswordButtonIsTapped(_ sender: UIButton) {
        isResettingPassword = !isResettingPassword
        passwordTextField.isHidden = true
        confirmPasswordTextField.isHidden = true
        loginButton.setTitle("RESET PASSWORD", for: .normal)
        additionalButtons[1].setTitle("Create Account", for: .normal)
        sender.isHidden = true
    }
    
    // MARK:- VIEW LIFE CYCLE METHODS

    override func viewDidLoad() {
        super.viewDidLoad()
        view!.addSubview(backgroundImageView)
        view!.addSubview(stackView)
        customizeSubviews()
        becomeTextFieldDelegates() 
    }
    
    // MARK:- PRIVATE METHODS

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
                let blurredSubview = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
                self.view.addBlurredSubview(blurredSubview)
                let alert = UIAlertController(title: "Sign In Error", message: firebaseError.localizedDescription, preferredStyle: .alert)
                alert.view.tintColor = .outgoingLavender
                alert.view.backgroundColor = .black
                alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: {(_) in
                    blurredSubview.removeFromSuperview()
                }))
                UIApplication.shared.keyWindow!.rootViewController?.present(alert, animated: true, completion: nil)
                return
            }
            self.login(with: self.emailTextField.text!)
        })
    }
    
    private func signUp() {
        if passwordTextField.text == confirmPasswordTextField.text {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
                if let firebaseError = error {
                    let blurredSubview = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
                    self.view.addBlurredSubview(blurredSubview)
                    let alert = UIAlertController(title: "Sign Up Error", message: firebaseError.localizedDescription, preferredStyle: .alert)
                    alert.view.tintColor = .outgoingLavender
                    alert.view.backgroundColor = .black
                    alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: {(_) in
                        blurredSubview.removeFromSuperview()
                    }))
                    UIApplication.shared.keyWindow!.rootViewController?.present(alert, animated: true, completion: nil)
                    return
                }
                self.login(with: self.emailTextField.text!)
            })
        } else {
            let blurredSubview = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
            self.view.addBlurredSubview(blurredSubview)
            let alert = UIAlertController(title: "Sign Up Error", message: "Passwords do not match", preferredStyle: .alert)
            alert.view.tintColor = .outgoingLavender
            alert.view.backgroundColor = .black
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: {(_) in
                blurredSubview.removeFromSuperview()
            }))
            UIApplication.shared.keyWindow!.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    private func resetPassword() {
        let blurredSubview = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

        if emailTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Reset Password Error", message: "Text field is empty", preferredStyle: .alert)
            alert.view.tintColor = .outgoingLavender
            alert.view.backgroundColor = .black
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: {(_) in
                blurredSubview.removeFromSuperview()
            }))
            UIApplication.shared.keyWindow!.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            if error != nil {
                let alert = UIAlertController(title: "Success", message: "You have received an e-mail ", preferredStyle: .alert)
                alert.view.tintColor = .outgoingLavender
                alert.view.backgroundColor = .black
                alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: {(_) in
                    blurredSubview.removeFromSuperview()
                }))
                UIApplication.shared.keyWindow!.rootViewController?.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Reset Password Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.view.tintColor = .outgoingLavender
                alert.view.backgroundColor = .black
                alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: {(_) in
                    blurredSubview.removeFromSuperview()
                }))
                UIApplication.shared.keyWindow!.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
        clean()
    }
    
    private func clean() {
        emailTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
    }
}

// MARK:- TEXT FIELD DELEGATE

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
