//
//  ReserveRegistrationViewController.swift
//  InYerevan
//
//  Created by HarutMikichyan on 1/8/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import UIKit
import Firebase

class ReserveRegistrationViewController: UIViewController {
    
    @IBOutlet weak var registrationView: UIView!
    @IBOutlet var hotelRegistrationView: UIView!
    @IBOutlet var restaurantRegistrationView: UIView!
    
    //MARK: -TextField Outlet
    // hotel outlet
    @IBOutlet weak var hotelName: UITextField!
    @IBOutlet weak var hotelStar: UITextField!
    @IBOutlet weak var hotelPhoneNumber: UITextField!
    @IBOutlet weak var openingHoursHotel: UITextField!
    @IBOutlet weak var hotelLocation: UIMapInputTextField!
    
    //restaurant outlet
    @IBOutlet weak var restaurantName: UITextField!
    @IBOutlet weak var restaurantPhoneNumber: UITextField!
    @IBOutlet weak var openingHoursRestaurant: UITextField!
    @IBOutlet weak var restaurantLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registrationView.addSubview(hotelRegistrationView)
        hotelRegistrationView.frame = registrationView.bounds
        
        //registration View layer
        registrationView.layer.cornerRadius = 12
        registrationView.clipsToBounds = true
        registrationView.layer.borderWidth = 2
        registrationView.layer.borderColor = UIColor.blue.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
        
        //registration View layer
        registrationView.layer.cornerRadius = 12
        registrationView.clipsToBounds = true
        registrationView.layer.borderWidth = 2
        registrationView.layer.borderColor = UIColor.blue.cgColor
    }
    
    @IBAction func segmentControllRegistration(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            restaurantRegistrationView.removeFromSuperview()
            registrationView.addSubview(hotelRegistrationView)
            hotelRegistrationView.frame = registrationView.bounds
        case 1:
            hotelRegistrationView.removeFromSuperview()
            registrationView.addSubview(restaurantRegistrationView)
            restaurantRegistrationView.frame = registrationView.bounds
        default:
            break
        }
    }
    
    @IBAction func dismissRegistrationView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addHotel(_ sender: Any) {
        if hotelName.text != "" && hotelStar.text != "" && hotelPhoneNumber.text != ""
            && openingHoursHotel.text != "" && hotelLocation.text != "" {
            
            let keyHotel: String! = UIApplication.appDelegate.refHotels.childByAutoId().key
            let hotLoc: (lat: Double, long: Double) = self.hotelLocation.getCoordinatesAsTuple()
            
            let hotel: [String: Any] = ["id": keyHotel, "hotelName": hotelName.text! , "hotelStar": hotelStar.text! , "hotelPhoneNumber": hotelPhoneNumber.text! , "openingHoursHotel": openingHoursHotel.text!, "hotelLocationLong": hotLoc.long , "hotelLocationLat": hotLoc.lat]
            
            UIApplication.appDelegate.refHotels.child(keyHotel).setValue(hotel)
        }
    }
    
    @IBAction func addRestaurant(_ sender: Any) {
        if restaurantName.text != "" && restaurantPhoneNumber.text != ""
            && openingHoursRestaurant.text != "" && restaurantLocation.text != "" {
            
            let keyRestaurant = UIApplication.appDelegate.refRestaurants.childByAutoId().key
            
            let restaurant = ["id": keyRestaurant, "restaurantName": restaurantName.text, "restaurantPhoneNumber": restaurantPhoneNumber.text, "openingHoursRestaurant": openingHoursRestaurant.text, "restaurantLocation": restaurantLocation.text]
            
            UIApplication.appDelegate.refRestaurants.child(keyRestaurant!).setValue(restaurant)
        }
    }
}
