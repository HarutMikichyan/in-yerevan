//
//  ProfileViewController.swift
//  In Yerevan
//
//  Created by Gev Darbinyan on 17/12/2018.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK:- OTHER PROPERTIES

    @IBOutlet weak var userNickname: UILabel!
    @IBOutlet weak var changeEmail: UIButton!
    @IBOutlet weak var changePassword: UIButton!
    @IBOutlet weak var userImageView: UIImageView!

    
    // MARK:- VIEW LIFE CYCLE METHODS

    override func viewDidLoad() {
        super.viewDidLoad()

        if User.email == "guest" {
            changeEmail.isEnabled = false
            changeEmail.setTitleColor(UIColor.white, for: .normal)
            changeEmail.backgroundColor = UIColor.white
            
            changePassword.isEnabled = false
            changePassword.setTitleColor(UIColor.white, for: .normal)
            changePassword.backgroundColor = UIColor.white
        }
    }

    // MARK:- ACTIONS

    @IBAction func changeEmailAction() {
    }
    
    @IBAction func changePasswordAction() {
    }
    
    @IBAction func signOutAction() {
        
        User.email = ""
        
        let myStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = myStoryboard.instantiateViewController(withIdentifier: "registrationvc")
        
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
}
