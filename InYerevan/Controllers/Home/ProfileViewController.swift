//
//  ProfileViewController.swift
//  In Yerevan
//
//  Created by Gev Darbinyan on 17/12/2018.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userNickname: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var changeEmail: UIButton!
    @IBOutlet weak var changePassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func changeEmailAction() {
    }
    @IBAction func changePasswordAction() {
    }
    @IBAction func signOutAction() {
        let myStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = myStoryboard.instantiateViewController(withIdentifier: "LoginRegistrationViewController")
        
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
}
