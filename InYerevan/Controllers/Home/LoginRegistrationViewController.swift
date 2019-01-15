//
//  LoginRegistrationViewController.swift
//  In Yerevan
//
//  Created by Gev Darbinyan on 17/12/2018.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginRegistrationViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var uIView: UIView!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var GSignIn: GIDSignInButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginErrorLabel: UILabel!
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    @IBOutlet weak var registrationView: UIView!
    @IBOutlet weak var registrationErrorLabel: UILabel!
    @IBOutlet weak var registrationEmailTextField: UITextField!
    @IBOutlet weak var registrationPasswordTextField: UITextField!
    @IBOutlet weak var registrationRepeatPasswordTextField: UITextField!
    
    @IBOutlet weak var resetView: UIView!
    @IBOutlet weak var resetErrorLabel: UILabel!
    @IBOutlet weak var resetEmailTextField: UITextField!
    
    private var isFirstLoad: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loginEmailTextField.delegate = self
        loginPasswordTextField.delegate = self
        registrationEmailTextField.delegate = self
        registrationPasswordTextField.delegate = self
        registrationRepeatPasswordTextField.delegate = self
        resetEmailTextField.delegate = self
        homeImage.layer.cornerRadius = 12
        homeImage.layer.masksToBounds = true
        
        GIDSignIn.sharedInstance().uiDelegate = self
        // GIDSignIn.sharedInstance()?.signInSilently()
        
        // Log out-i jamanak ogtagorcel
        // GIDSignIn.sharedInstance()?.signOut()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirstLoad {
            uIView.addSubview(loginView)
            loginView.frame = uIView.bounds
            isFirstLoad = !isFirstLoad
        }
    }
    
    @IBAction func loginAction() {
        Auth.auth().signIn(withEmail: loginEmailTextField.text!, password: loginPasswordTextField.text!, completion: {(user, error) in
            if let firebaseError = error {
                self.loginErrorLabel.text = firebaseError.localizedDescription
                return
            }
            self.logIn(userEmail: self.loginEmailTextField.text!)
        })
    }
    
    @IBAction func scipForNowAction() {
        logIn(userEmail: "guest")
    }
    
    @IBAction func registrationAction() {
        if registrationPasswordTextField.text! != registrationRepeatPasswordTextField.text! {
            registrationErrorLabel.text = "Password doesn't match."
            return
        }
        Auth.auth().createUser(withEmail: registrationEmailTextField.text!, password: registrationPasswordTextField.text!, completion: {(user, error) in
            if let firebaseError = error {
                self.registrationErrorLabel.text = firebaseError.localizedDescription
                return
            }
            
            self.logIn(userEmail: self.registrationEmailTextField.text!)
        })
    }
    
    @IBAction func changePasswordAction() {
        //Auth.auth().isSignIn(withEmailLink: <#T##String#>)
    }
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            resetClean()
            registrationClean()
            uIView.addSubview(loginView)
            loginView.frame = uIView.bounds
        case 1:
            resetClean()
            loginClean()
            uIView.addSubview(registrationView)
            registrationView.frame = uIView.bounds
        case 2:
            loginClean()
            registrationClean()
            uIView.addSubview(resetView)
            resetView.frame = uIView.bounds
        default:
            break
        }
    }
    
    func loginClean() {
        loginErrorLabel.text = ""
        loginEmailTextField.text = ""
        loginPasswordTextField.text = ""

        loginView.removeFromSuperview()
    }

    func registrationClean() {
        registrationErrorLabel.text = ""
        registrationEmailTextField.text = ""
        registrationPasswordTextField.text = ""
        registrationRepeatPasswordTextField.text = ""

        registrationView.removeFromSuperview()
    }

    func resetClean() {
        resetErrorLabel.text = ""
        resetEmailTextField.text = ""

        resetView.removeFromSuperview()
    }

    func logIn(userEmail: String) {
        var isAdministration: Bool = false

        for item in User.administration {
            if item == userEmail {
                isAdministration = true
                break
            }
        }

        User.email = userEmail
        User.isAdministration = isAdministration

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController")

        self.show(vc, sender: nil)
    }
}

extension LoginRegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginEmailTextField {
            loginPasswordTextField.becomeFirstResponder()
        }
        if textField == loginPasswordTextField {
            loginPasswordTextField.endEditing(true)
            loginAction()
        }
        
        if textField == registrationEmailTextField {
            registrationPasswordTextField.becomeFirstResponder()
        }
        if textField == registrationPasswordTextField {
            registrationRepeatPasswordTextField.becomeFirstResponder()
        }
        if textField == registrationRepeatPasswordTextField {
            registrationRepeatPasswordTextField.endEditing(true)
            registrationAction()
        }
        
        if textField == resetEmailTextField {
            resetEmailTextField.endEditing(true)
            // TO DO: resetAction
        }
        return true
    }
}
