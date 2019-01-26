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

class HotelRestaurantMapTableViewCell: UITableViewCell, MKMapViewDelegate, CLLocationManagerDelegate {
    static let id = "HotelRestaurantMapTableViewCell"

    //MARK:- Interface Builder Outlets
    @IBOutlet weak var textMap: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK:- Other Properties
    private let locationManager = CLLocationManager()
    
    var openingHours: String! {
        didSet {
            if name != nil && locationLong != nil && locationLat != nil {
                showLocation()
            }
        }
    }
    var name: String! {
        didSet {
            if openingHours != nil && locationLong != nil && locationLat != nil {
                showLocation()
            }
        }
    }
    
    var locationLat: Double! {
        didSet {
            if openingHours != nil && locationLong != nil && name != nil {
                showLocation()
            }
        }
    }
    
    var locationLong: Double! {
        didSet {
            if openingHours != nil && locationLat != nil && name != nil {
                showLocation()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func showLocation() {
        let pin = MKPointAnnotation()
        pin.title = "Title: \(name!), Opening Hours: \(openingHours!)"
                    pin.coordinate = CLLocationCoordinate2DMake(locationLat, locationLong)
        mapView.addAnnotation(pin)
        pin.coordinate = CLLocationCoordinate2D(latitude: locationLat, longitude: locationLong)
        let pinAnnotationView = MKPinAnnotationView(annotation: pin, reuseIdentifier: nil)
        mapView.centerCoordinate = pin.coordinate
        mapView.addAnnotation(pinAnnotationView.annotation!)
        
        let region = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 1000.0, longitudinalMeters: 1000.0)
        mapView.setRegion(region, animated: true)
    }
}

    

    

