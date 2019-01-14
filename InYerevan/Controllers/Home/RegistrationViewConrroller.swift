//
//  RegistrationViewController.swift
//  InYerevan
//
//  Created by Vahram Tadevosian on 1/13/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var additionalButtons: [UIButton]!
    
    private var isSigningUp: Bool = false
    private var isResettingPassword: Bool = false
    
    @IBAction func signUpButtonIsTapped(_ sender: UIButton) {
        isSigningUp = !isSigningUp

        if isResettingPassword {
            additionalButtons.forEach { button in
                button.isHidden = false
            }
            isResettingPassword = !isResettingPassword
            isSigningUp = true
        }
        
        passwordTextField.isHidden = false
        if isSigningUp {
            confirmPasswordTextField.isHidden = false
            loginButton.setTitle("SIGN UP", for: .normal)
            sender.setTitle("Log In", for: .normal)
        } else {
            confirmPasswordTextField.isHidden = true
            loginButton.setTitle("LOG IN", for: .normal)
            sender.setTitle("Create Account", for: .normal)
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view!.addSubview(backgroundImageView)
        view!.addSubview(stackView)

        let trailingConstant = backgroundImageView.bounds.width - (0.18 * backgroundImageView.bounds.width)
        
        backgroundImageView.addConstraints(equalToConstraintsOf: view, withTrailingConstant: trailingConstant,
                          leadingConstant: 0, bottomConstant: 0, topConstant: 0)
        stackView.addConstraints(equalToConstraintsOf: view, withHeightMultiplier: 0.25,
                             widthMultiplier: 0.45, centerXMultiplier: 1, centerYMultiplier: 0.8)
        
        let height = view.bounds.height
        stackView.spacing = height / 110
        //h/70
        
        emailTextField.customize(by: view, placeholder: "Email")
        passwordTextField.customize(by: view, placeholder: "Password")
        confirmPasswordTextField.customize(by: view, placeholder: "Repeat password")
        
        loginButton.customize(by: view, shouldBeRound: true)
        additionalButtons.forEach({ button in
            button.customize(by: view, shouldBeRound: false)
        })
        
    }
    

}
