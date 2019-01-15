//
//  EventViewController.swift
//  In Yerevan
//
//  Created by Davit Ghushchyan on 12/17/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import MapKit

class EventViewController: UIViewController {
static let id = "EventViewController"
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var visitorsLabel: UILabel!
    
    var event: Event! 
    
    
    var imagesForEvent = [#imageLiteral(resourceName: "Trades"),#imageLiteral(resourceName: "City"),#imageLiteral(resourceName: "Technology"),#imageLiteral(resourceName: "Trades"),#imageLiteral(resourceName: "Cinema")]
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateTuple = event.date!.toString()
        dayLabel.text = dateTuple.day
        monthLabel.text = dateTuple.month
        title = event.title!
        visitorsLabel.text = "We have \(event.visitorsCount) visitors"
        detailsTextView.text = event.details
        detailsTextView.isEditable = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addToCalendarAction() {
        // TODO: - functionality to interact with native Calendar
        event.visitorsCount += 1 
        UIApplication.appDelegate.dataManager.saveViewContext()
        visitorsLabel.text = "We have \(event.visitorsCount) visitors"
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
