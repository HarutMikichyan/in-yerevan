//
//  AppDelegate.swift
//  In Yerevan
//
//  Created by Gev Darbinyan on 11/12/2018.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataManager: DataManager!
    var persistentController: PersistentController!
    let queue = DispatchQueue(label: "FetchQueue")
    
    // HotelsRestaurants Databse reference
    var refHotels: DatabaseReference!
    var refRestaurants: DatabaseReference!

    override init() {
        FirebaseApp.configure()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
 
        refHotels = Database.database().reference().child("Hotels")
        refRestaurants = Database.database().reference().child("Restaurants")
        
        persistentController = PersistentController()
        dataManager = DataManager(persistentController)
        
        //FetchEvents and replace CoreData
        queue.async {
            self.dataManager.fetchEventsFromServerSide()
        }
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        if !User.email.isEmpty {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()

        }
        
        // Initialize the Google Mobile Ads SDK.
        GADMobileAds.configure(withApplicationID: "ca-app-pub-8835408910987382~7140944451")
        
      return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
       persistentController.saveViewContext()
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
