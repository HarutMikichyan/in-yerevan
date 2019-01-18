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
    @IBOutlet weak var signOutButton: UIButton!
    
    
    // MARK:- VIEW LIFE CYCLE METHODS

    override func viewDidLoad() {
        super.viewDidLoad()

        userNickname.text = User.email

        changeEmail.layer.cornerRadius = 12
        changeEmail.layer.masksToBounds = true

        changePassword.layer.cornerRadius = 12
        changePassword.layer.masksToBounds = true

        signOutButton.layer.cornerRadius = 12
        signOutButton.layer.masksToBounds = true

//        if User.email == "guest" {
//            changeEmail.isEnabled = false
//            changeEmail.setTitleColor(UIColor.white, for: .normal)
//            changeEmail.backgroundColor = UIColor.white
//
//            changePassword.isEnabled = false
//            changePassword.setTitleColor(UIColor.white, for: .normal)
//            changePassword.backgroundColor = UIColor.white
//
//        }
        view.changeBackgroundToGradient(from: [.backgroundDarkSpruce, .backgroundDenimBlue])

    }

    // MARK:- ACTIONS

    @IBAction func changeEmailAction() {
    }
    
    @IBAction func changePasswordAction() {
    }
    
    @IBAction func signOutAction() {
        
        User.email = ""
        User.isAdministration = false
        
        let myStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = myStoryboard.instantiateViewController(withIdentifier: "registrationvc")
        
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
}
