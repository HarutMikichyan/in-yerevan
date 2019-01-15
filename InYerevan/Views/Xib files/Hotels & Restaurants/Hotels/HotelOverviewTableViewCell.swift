//
//  HotelOverviewTableViewCell.swift
//  InYerevan
//
//  Created by HarutMikichyan on 1/8/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import UIKit
import Cosmos

class HotelOverviewTableViewCell: UITableViewCell {
    
    static let id = "HotelOverviewTableViewCell"
    
    //Mark: - reviews view
    lazy var cosmosView: CosmosView = {
        let view = CosmosView()
        
        view.settings.starSize = 32
        view.settings.starMargin = 8.8
        view.settings.fillMode = .precise
        view.settings.filledBorderColor = .blue
        view.settings.emptyBorderColor = .blue
        view.settings.filledColor = .blue
        return view
    }()
    
    var hotelId: String!
    
    @IBOutlet weak var hotelPhoneNumber: UILabel!
    @IBOutlet weak var hotelPrice: UILabel!
    
    @IBOutlet weak var star: UILabel!
    @IBOutlet weak var openingHours: UILabel!
    @IBOutlet weak var fromDateField: DatePickerInputTextField!
    @IBOutlet weak var toDateField: DatePickerInputTextField!
    
    @IBOutlet weak var rateView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.addSubview(cosmosView)
        
        cosmosConstraint()
    }
    
    func cosmosConstraint() {
        cosmosView.translatesAutoresizingMaskIntoConstraints = false
        
        cosmosView.topAnchor.constraint(equalTo: rateView.topAnchor, constant: 16).isActive = true
        cosmosView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
    }
    
    @IBAction func priceHotel(_ sender: Any) {
//        if fromDateField.text != "" && toDateField.text != "" {
//            var timeInterval = fromDateField.getValue().timeIntervalSince(toDateField.getValue())
//            if timeInterval < 0 {
//                var day = timeInterval as! Double / 1440.0 * 60.0
//                print()
//
//            }
//        }
    }
    
    @IBAction func rateHotel(_ sender: Any) {
        //animate
        let theButton = sender as! UIButton
        let baunds = theButton.bounds
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            theButton.bounds = CGRect(x: baunds.origin.x - 20, y: baunds.origin.y, width: baunds.size.width + 60, height: baunds.size.height)
        }, completion: { (success: Bool) in
            if success {
                theButton.bounds = baunds
            }
        })
        
//        UIApplication.appDelegate.refHotels.observe(.value) { (snapshot) in
//            
//            if snapshot.childrenCount > 0 {
//                self.hotelId.removeAll()
//                for hot in snapshot.children.allObjects as! [DataSnapshot] {
//                    let hotelObject = hot.value as! [String: AnyObject]
//                    let id = hotelObject["id"]
//                    self.hotelId = id as! String
//                    break
//                }
//            }
//        }
//        UIApplication.appDelegate.refHotels.child("Hotels").child(self.hotelId).updateChildValues(["openingHoursHotel": "eeeeeee"])
    }
}
