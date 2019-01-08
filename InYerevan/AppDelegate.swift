//
//  AppDelegate.swift
//  In Yerevan
//
//  Created by Gev Darbinyan on 11/12/2018.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataManager: DataManager!
    var persistentController: PersistentController!

    override init() {
        FirebaseApp.configure()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ///---------subject to change----------///
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userStateDidChange),
            name: Notification.Name.AuthStateDidChange,
            object: nil
        )
        ///-----------------------------------///
        
        persistentController = PersistentController()
        dataManager = DataManager(persistentController)
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
       persistentController.saveViewContext()
    }
    
    
    // MARK:- HELPER FUNCTIONS
    
    @objc internal func userStateDidChange() {
        DispatchQueue.main.async {
            self.handleAppState()
        }
    }
    
    ///---------subject to change----------///
    private func handleAppState() {
        let sb = UIStoryboard.init(name: "CustomerSupport", bundle: nil)
        if let user = Auth.auth().currentUser {
            //            let vc = sb.instantiateViewController(withIdentifier: "userlist") as! UserListViewController
            //            vc.currentUser = user
            //            window?.rootViewController = vc
        } else {
            let vc = sb.instantiateViewController(withIdentifier: "login")
            window?.rootViewController = vc
        }
    }
    ///-----------------------------------///
    
}

extension UIApplication {
    // Easy Access to AppDelegate
    static var appDelegate: AppDelegate {
        return shared.delegate as! AppDelegate
    }
    
    // Easy Access to dataManager
    static var dataManager: DataManager {
        return appDelegate.dataManager
    }
}
