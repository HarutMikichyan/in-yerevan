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
    @IBOutlet weak var GSignIn: GIDSignInButton!
    @IBOutlet weak var resetEmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeImage.layer.cornerRadius = 12
        homeImage.layer.masksToBounds = true
        
        uIView.addSubview(loginView)
        loginView.frame = uIView.bounds
        
        GIDSignIn.sharedInstance().uiDelegate = self
        // GIDSignIn.sharedInstance()?.signInSilently()
        
        // Log out-i jamanak ogtagorcel
        // GIDSignIn.sharedInstance()?.signOut()
    }
    
    @IBAction func loginAction() {
        Auth.auth().signIn(withEmail: loginEmailTextField.text!, password: loginPasswordTextField.text!, completion: {(user, error) in
            if let firebaseError = error {
                self.loginErrorLabel.text = firebaseError.localizedDescription
                return
            }
            self.logIn(userEmail: self.loginEmailTextField.text!, isAdministration: false)
        })
    }
    
    @IBAction func scipForNowAction() {
        logIn(userEmail: "guest", isAdministration: false)
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
            self.logIn(userEmail: self.loginEmailTextField.text!, isAdministration: false)
        })
    }
    
    @IBAction func signInWithMailAction() {
        //        Auth.auth().signInAndRetrieveData(with: signInButton!, completion: {(authResult, error) in
        //            if let error = error {
        //                // ...
        //                return
        //            }
        //            // User is signed in
        //            // ...
        //        })
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
    
    func logIn(userEmail: String, isAdministration: Bool) {
        UserDefaults.standard.set(userEmail, forKey: "userEmail")
        UserDefaults.standard.set(isAdministration, forKey: "isAdministration")
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.viewControllers = [vc]
    }
}
