//
//  PHPhotoLibrary+ AuthRequest.swift
//  In Yerevan
//
//  Created by Davit Ghushchyan on 12/29/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import Photos 

extension PHPhotoLibrary {
    
   static func requestAuthIfNeeded() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .denied: 
            let alert = UIAlertController(title: "Photos Access Denied", message: "App needs access to photos library.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style: .destructive, handler: { (_) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            UIApplication.shared.keyWindow!.rootViewController?.present(alert, animated: true, completion: nil)
        case .restricted: 
            let alert = UIAlertController(title: "Photos Access Restricted", message: "App needs access to photos library.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            UIApplication.shared.keyWindow!.rootViewController?.present(alert, animated: true, completion: nil)
        default:
            PHPhotoLibrary.requestAuthorization { (status) in
                if status != .authorized{
                    let alert = UIAlertController(title: "Photos Access Denied", message: "App needs access to photos library.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    UIApplication.shared.keyWindow!.rootViewController?.present(alert, animated: true, completion: nil)
                }
            } // auth closure
        } // switch     
    } // Func
    
}
