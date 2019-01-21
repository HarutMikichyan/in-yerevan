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
    var locationLat: Double!
    var locationLong: Double!
    var openingHours: String!
    var name: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        mapView.mapType = .hybrid
//
        mapView.showsUserLocation = true
//
        if let location = locationManager.location {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 50000.0, longitudinalMeters: 50000.0)
            mapView.setRegion(region, animated: true)
        }
    }
}

extension HotelRestaurantMapTableViewCell: MKMapViewDelegate, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2DMake(locationLat, locationLong)
        self.mapView.addAnnotation(pin)
        
        let region = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        self.mapView.setRegion(region, animated: true)
    }
}

    

    

    

