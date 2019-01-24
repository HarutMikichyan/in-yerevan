//
//  CategoryTableViewCell.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/20/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    static let id = "CategoryTableViewCell"
    
    //MARK:- Interface Builder Outlets
    @IBOutlet weak var addHotels: UIView!
    @IBOutlet weak var addRestaurants: UIView!
    
    //MARK: -GestureRecognizer
    var parrentViewController: UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hotelRestaurantGestureRecognzer()
    }
    
    //MARK: -GestureRecognizer
    func hotelRestaurantGestureRecognzer() {
        let hotelViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pushHotels))
        hotelViewGestureRecognizer.numberOfTapsRequired = 1
        addHotels.isUserInteractionEnabled = true
        addHotels.addGestureRecognizer(hotelViewGestureRecognizer)
        
        let restaurantsViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pushRestaurants))
        restaurantsViewGestureRecognizer.numberOfTapsRequired = 1
        addRestaurants.isUserInteractionEnabled = true
        addRestaurants.addGestureRecognizer(restaurantsViewGestureRecognizer)
    }
    
    @objc func pushHotels() {
        let storyboard = UIStoryboard(name: "HotelsAndRestaurants", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HotelsViewControllerID")
        parrentViewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pushRestaurants() {
        let storyboard = UIStoryboard(name: "HotelsAndRestaurants", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RestaurantsViewControllerID")
        parrentViewController.navigationController?.pushViewController(vc, animated: true)
    }
}
