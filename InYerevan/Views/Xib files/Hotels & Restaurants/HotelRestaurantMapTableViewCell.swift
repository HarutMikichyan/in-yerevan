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

final class Annotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        super.init()
    }
    
    var region: MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        return MKCoordinateRegion(center: coordinate, span: span)
    }
}

class HotelRestaurantMapTableViewCell: UITableViewCell, CLLocationManagerDelegate {

    static let id = "HotelRestaurantMapTableViewCell"
    var locationLat: Double!
    var locationLong: Double!
    var name: String!
    var openingHours: String!

    @IBOutlet weak var textMap: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
//        showUserLocation()
        
        if locationLong != nil && locationLat != nil {
            mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            
            let coordinate = CLLocationCoordinate2D(latitude: locationLat, longitude: locationLong)
            let annotation = Annotation(coordinate: coordinate, title: name, subtitle: openingHours)
            
            mapView.addAnnotation(annotation)
            mapView.setRegion(annotation.region, animated: true)
        }
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


    

    

    

