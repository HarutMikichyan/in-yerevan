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
    
    //MARK:- Interface Builder Outlets
    @IBOutlet weak var hotelPhoneNumber: UILabel!
    @IBOutlet weak var hotelPrice: UILabel!
    @IBOutlet weak var star: UILabel!
    @IBOutlet weak var openingHours: UILabel!
    @IBOutlet weak var fromDateField: DatePickerInputTextField!
    @IBOutlet weak var toDateField: DatePickerInputTextField!
    @IBOutlet weak var rateView: UIView!
    
    //MARK:- Other Properties
    var hotelId: String!
    var hotelRateCount: Int!
    var hotelRatesSum: Double!
    var hotelRate: Double!
    var hotPrice: Double! {
        didSet {
            hotelPrice.text = "AMD \(hotPrice!)"
        }
    }
    
    lazy var cosmosView: CosmosView = {
        let view = CosmosView()
        view.settings.starSize = 32
        view.settings.starMargin = 8.8
        view.settings.fillMode = .precise
        view.settings.filledBorderColor = .outgoingLavender
        view.settings.emptyBorderColor = .outgoingLavender
        view.settings.filledColor = .outgoingLavender
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
    
    //MARK: Actions
    @IBAction func priceHotel(_ sender: Any) {
        if fromDateField.text != "" && toDateField.text != "" {
            let timeInterval: Double = toDateField.getValue().timeIntervalSince(fromDateField.getValue())
            if timeInterval > 0.0 {
                let minute = timeInterval / 60.0
                let hourse = minute / 60.0
                let day = hourse / 24.0
                
                let dayPrice = (String)(format: "%.2f", day * hotPrice)
                hotelPrice.text = "AMD \(dayPrice)"
            }
        }
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
        
        UIApplication.appDelegate.refHotels.child(hotelId).child("rateCount").setValue(hotelRateCount! + 1)
        if hotelRateCount == 0 {
            let rateH = (String)(format: "%.4f", cosmosView.rating)
            UIApplication.appDelegate.refHotels.child(hotelId).child("rate").setValue(Double(rateH))
        } else {
            let rateH = (String)(format: "%.4f", Double(hotelRate + cosmosView.rating) / Double(2))
            UIApplication.appDelegate.refHotels.child(hotelId).child("rate").setValue(Double(rateH))
        }
    }
}
