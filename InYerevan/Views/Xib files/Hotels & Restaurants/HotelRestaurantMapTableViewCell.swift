//
//  HotelRestaurantMapTableViewCell.swift
//  InYerevan
//
//  Created by HarutMikichyan on 1/9/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HotelRestaurantMapTableViewCell: UITableViewCell {

    static let id = "HotelRestaurantMapTableViewCell"

    @IBOutlet weak var textMap: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        showUserLocation()
    }
    
    func showUserLocation() {
        locationManager.requestWhenInUseIfNeeded()
        mapView.mapType = .hybrid
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.showsUserLocation = true
        
        if let location = locationManager.location {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000.0, longitudinalMeters: 1000.0)
            mapView.setRegion(region, animated: true)
        }
    }
}


    

    

    

