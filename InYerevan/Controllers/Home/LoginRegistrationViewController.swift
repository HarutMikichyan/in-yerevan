//
//  LoginRegistrationViewController.swift
//  In Yerevan
//
//  Created by Gev Darbinyan on 17/12/2018.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class LoginRegistrationViewController: UIViewController {
    
    @IBOutlet weak var uIView: UIView!
    @IBOutlet weak var homeImage: UIImageView!
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    @IBOutlet weak var registrationView: UIView!
    @IBOutlet weak var registrationNicknameTextField: UITextField!
    @IBOutlet weak var registrationEmailTextField: UITextField!
    @IBOutlet weak var registrationPasswordTextField: UITextField!
    @IBOutlet weak var registrationRepeatPasswordTextField: UITextField!
    
    @IBOutlet weak var resetView: UIView!
    @IBOutlet weak var resetEmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeImage.layer.cornerRadius = 12
        homeImage.layer.masksToBounds = true
        
        uIView.addSubview(loginView)
        loginView.frame = uIView.bounds
    }

    @IBAction func loginAction() {
        
    }
    
    @IBAction func scipForNowAction() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.viewControllers = [vc]
    }
    
    @IBAction func registrationAction() {
        
    }
    
    @IBAction func signInWithMailAction() {
        
    }
    
    @IBAction func changePasswordAction() {
        
    }
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            resetView.removeFromSuperview()
            registrationView.removeFromSuperview()
            uIView.addSubview(loginView)
            loginView.frame = uIView.bounds
        case 1:
            loginView.removeFromSuperview()
            resetView.removeFromSuperview()
            uIView.addSubview(registrationView)
            registrationView.frame = uIView.bounds
        case 2:
            loginView.removeFromSuperview()
            registrationView.removeFromSuperview()
            uIView.addSubview(resetView)
            resetView.frame = uIView.bounds
        default:
            break
        }
    }
}
