//
//  MapInputTextField.swift
//  MapKeyboard
//
//  Created by Davit Ghushchyan on 12/23/18.
//  Copyright © 2018 Davit Ghushchyan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol UIMapInputTextFieldDelegate: UITextFieldDelegate {
    func pinLocationChangedTo(latitude: Double, longitude: Double)
}

class UIMapInputTextField: UITextField, UITextFieldDelegate {
    // the keyboard can send messages to the view controller.
    weak var mapDelegate: UIMapInputTextFieldDelegate?
    
    // MARK: - Variables
    private let locationManager = CLLocationManager()
    private let annotation = MKPointAnnotation()
    private let mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: 0, height: 280))
    
    // MARK: - Initializers 
    override init(frame: CGRect) {
        super.init(frame: frame)
        inputView = mapView
        prepareMap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        inputView =  mapView
        prepareMap()
    }
    
    // MARK: - Unarchive 
    override func awakeFromNib() {
        super.awakeFromNib() 
        prepareMap()
    }

    // MARK: - Prepareing for init 
    private func prepareMap() {
        disableUserManuallyInput()
        // MARK: - Button
        let doneButton = DoneButton()
        doneButton.addTarget(self, action: #selector(endEditing(_:)), for: .touchUpInside)
        inputAccessoryView = doneButton
        // MARK: - Map
        mapView.delegate = self
        mapView.addAnnotation(annotation)
        mapView.mapType = .hybrid
        mapView.showsUserLocation = true
        // MARK: - Location Services 
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseIfNeeded()
        if  let location =  locationManager.location {
            let region =  MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 20000.0, longitudinalMeters: 20000.0)
            mapView.setRegion(region, animated: true)
        } 
        // battery Friendly :) satelites have only 5 secounds to show correct location
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    private func  disableUserManuallyInput() {
        autocapitalizationType = .none
        autocorrectionType = .no
        smartDashesType = .no
        smartInsertDeleteType = .no
        smartQuotesType = .no
        spellCheckingType = .no
    }
    
    // MARK: - PUBLIC INTERFACE 
    func updateKeyboardSize(hight: CGFloat) {
        mapView.frame = CGRect(x: 0, y: 0, width: 0, height: hight)
    }
    
    func changeMapTypeTo(_ type: MKMapType) {
        mapView.mapType = type
    }
    
    func getCoordinates() -> CLLocationCoordinate2D {
        return annotation.coordinate
    }
    
    func getCoordinatesAsTuple() -> (lat: Double, long: Double) {
        return (lat: Double(getCoordinates().latitude), long: Double(getCoordinates().longitude))
    }
    
    func setCurrentLocation() {
        locationManager.requestWhenInUseIfNeeded()
        if  let location =  locationManager.location {
            let region =  MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 20000.0, longitudinalMeters: 20000.0)
            mapView.setRegion(region, animated: true)
            annotation.coordinate = region.center
            let latitude = String(format: "%.5f", region.center.latitude)
            let longitude = String(format: "%.5f", region.center.longitude)
            text = "Lat \(latitude), Lon \(longitude)"
        }
    }
}

extension UIMapInputTextField: MKMapViewDelegate {
    // MARK: - update pin possition
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let centre = mapView.region.center
        annotation.coordinate = centre       
        mapDelegate?.pinLocationChangedTo(latitude: Double(centre.latitude), longitude: Double(centre.longitude))
        let latitude = String(format: "%.5f", centre.latitude)
        let longitude = String(format: "%.5f", centre.longitude)
        text = "Lat \(latitude), Lon \(longitude)"
    }
}
