//
//  CLLocationManager+ AuthRequest.swift
//  In Yerevan
//
//  Created by Davit Ghushchyan on 12/26/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import CoreLocation
import UIKit

extension CLLocationManager {
    func requestWhenInUseIfNeeded() {
        switch CLLocationManager.authorizationStatus() {
        case .restricted: 
            let alert = UIAlertController(title: "Location restricted", message: "We Can't use your location", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            UIApplication.shared.keyWindow!.rootViewController?.present(alert, animated: true, completion: nil)
        case .denied:
            let alert = UIAlertController(title: "Location denied", message: "We Can't use your location: reason - denied", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style: .destructive, handler: { (_) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            UIApplication.shared.keyWindow!.rootViewController?.present(alert, animated: true, completion: nil)
        default: 
            requestAlwaysAuthorization()
        }
    }
}
