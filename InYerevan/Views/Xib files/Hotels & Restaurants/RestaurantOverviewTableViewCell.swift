//
//  RestaurantOverviewTableViewCell.swift
//  InYerevan
//
//  Created by HarutMikichyan on 1/12/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import UIKit
import Cosmos

class RestaurantOverviewTableViewCell: UITableViewCell {
    static let id = "RestaurantOverviewTableViewCell"
    
    //MARK:- Interface Builder Outlets
    @IBOutlet weak var restaurantPhoneNumber: UILabel!
    @IBOutlet weak var restaurantOpeningHours: UILabel!
    @IBOutlet weak var rateView: UIView!
    
    var resPrice: Double!
    var restaurantId: String!
    var restaurantRateCount: Int!
    var restaurantRatesSum: Double!
    var restaurantRate: Double!
    
    //MARK:- Rate View
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.addSubview(cosmosView)
        cosmosConstraint()
    }
    
    
    //MARK: Rate Methods
    func cosmosConstraint() {
        cosmosView.translatesAutoresizingMaskIntoConstraints = false
        cosmosView.topAnchor.constraint(equalTo: rateView.topAnchor, constant: 16).isActive = true
        cosmosView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
    }
    
    //MARK:- Action
    @IBAction func rateRestaurant(_ sender: Any) {
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
        
        UIApplication.appDelegate.refHotels.child(restaurantId).child("rateCount").setValue(restaurantRateCount + 1)
        if restaurantRate == 0.0 {
            UIApplication.appDelegate.refRestaurants.child(restaurantId).child("rate").setValue(cosmosView.rating)
        } else {
            let rateR = (String)(format: "%.4f", restaurantRate + cosmosView.rating / Double(2))
            UIApplication.appDelegate.refRestaurants.child(restaurantId).child("rate").setValue(Double(rateR))
        }
    }
}
