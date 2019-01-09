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
    
    static var refHotel: DatabaseReference!
    var hotelsList = [HotelModel]()
    
    @IBOutlet weak var registrationView: UIView!
    @IBOutlet var hotelRegistrationView: UIView!
    @IBOutlet var restaurantRegistrationView: UIView!
    
    //MARK: -TextField Outlet
    @IBOutlet weak var hotelName: UITextField!
    @IBOutlet weak var hotelStar: UITextField!
    @IBOutlet weak var hotelPhoneNumber: UITextField!
    @IBOutlet weak var openingHoursHotel: UITextField!
    @IBOutlet weak var hotelLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ReserveRegistrationViewController.refHotel = Database.database().reference().child("Hotel")
        
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
        let key = ReserveRegistrationViewController.refHotel.childByAutoId().key
        
        let hotel = ["id": key, "hotelName": hotelName.text! as String, "hotelStar": hotelStar.text! as String, "hotelPhoneNumber": hotelPhoneNumber.text! as String, "openingHoursHotel": openingHoursHotel.text! as String, "hotelLocation": hotelLocation.text! as String]
        
        ReserveRegistrationViewController.refHotel.child(key!).setValue(hotel)
    }
}
