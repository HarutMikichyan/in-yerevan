//
//  AppDelegate.swift
//  In Yerevan
//
//  Created by Gev Darbinyan on 11/12/2018.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var dataManager: DataManager!
    var persistentController: PersistentController!
    
    // HotelsRestaurants Databse reference
    var refHotels: DatabaseReference!
    var refRestaurants: DatabaseReference!

    override init() {
        FirebaseApp.configure()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ///---------subject to change----------///
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(userStateDidChange),
//            name: Notification.Name.AuthStateDidChange,
//            object: nil
//        )
 
        refHotels = Database.database().reference().child("Hotels")
        refRestaurants = Database.database().reference().child("Restaurants")
        
        
        ///-----------------------------------///
        
        persistentController = PersistentController()
        dataManager = DataManager(persistentController)
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        GIDSignIn.sharedInstance()?.clientID = "127608008778-kdfb153i4f8kja6gm8o9pu0pra2ms0p9.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        persistentController = PersistentController()
        dataManager = DataManager(persistentController)

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
       persistentController.saveViewContext()
    }
    
//    // Kardal incha anum -------
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//
//        return GIDSignIn.sharedInstance().handle(url,
//                                                 sourceApplication: sourceApplication,
//                                                 annotation: annotation)
//    }
    
    // MARK: GIDSignInDelegate conform
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error)
        } else {
            print(user)
        }
        //        if let error = error {
        //            print("\(error.localizedDescription)")
        //        } else {
        //            // Perform any operations on signed in user here.
        //            let userId = user.userID                  // For client-side use only!
        //            let idToken = user.authentication.idToken // Safe to send to the server
        //            let fullName = user.profile.name
        //            let givenName = user.profile.givenName
        //            let familyName = user.profile.familyName
        //            let email = user.profile.email
        //            // ...
        //        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
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
