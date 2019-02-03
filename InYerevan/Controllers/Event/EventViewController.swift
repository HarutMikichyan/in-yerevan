//
//  EventViewController.swift
//  In Yerevan
//
//  Created by Davit Ghushchyan on 12/17/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EventViewController: UIViewController {
static let id = "EventViewController"
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var detailsTextView: UITextView!

    
    var event: Event! 
    
    
    var imagesForEvent = [UIImage]()
    
    override func viewDidLoad() {
        view.changeBackgroundToGradient(from: [.backgroundDarkSpruce, .backgroundDenimBlue])
        super.viewDidLoad()
        view.changeBackgroundToGradient(from: [.backgroundDarkSpruce, .backgroundDenimBlue])
        let dateTuple = event.date!.toString()
        dayLabel.text = dateTuple.day
        monthLabel.text = dateTuple.month
        title = event.title!
        detailsTextView.text = event.details
        detailsTextView.isEditable = false
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseIfNeeded()
        mapView.showsUserLocation = true
        if  let location =  locationManager.location {
            let region =  MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 20000.0, longitudinalMeters: 20000.0)
            mapView.setRegion(region, animated: true)
        }
        mapView.layer.borderWidth = 1 
        mapView.layer.borderColor = UIColor.outgoingLavender.cgColor
        mapView.clipsToBounds = true
        
        event.images
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let location = event.location
        let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: location!.latitude)!, longitude: CLLocationDegrees(exactly: location!.longitude)!)
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 200.0, longitudinalMeters: 200.0)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let location = event.location
        let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: location!.latitude)!, longitude: CLLocationDegrees(exactly: location!.longitude)!)
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 200.0, longitudinalMeters: 200.0)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
        
        
    }
    
    @IBAction func addToCalendarAction() {
        // TODO: - functionality to interact with native Calendar
        UIApplication.appDelegate.dataManager.saveViewContext()
    }
    
}

extension EventViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return imagesForEvent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventPictureCollectionViewCell.id, for: indexPath) as! EventPictureCollectionViewCell
        cell.prepareCellWith(background: imagesForEvent[indexPath.row])
        return cell
    }
    
    
    
}

extension EventViewController: MKMapViewDelegate {
    
}
