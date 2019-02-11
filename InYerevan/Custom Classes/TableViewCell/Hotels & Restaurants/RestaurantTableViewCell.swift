//
//  RestaurantTableViewCell.swift
//  InYerevan
//
//  Created by HarutMikichyan on 1/9/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    static let id = "RestaurantTableViewCell"
    
    @IBOutlet weak var imageRestaurant: UIImageView!
    @IBOutlet weak var nameRestaurant: UILabel!
    @IBOutlet weak var priceRestaurant: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageRestaurant.layer.cornerRadius = 12
        imageRestaurant.clipsToBounds = true
        selectionStyle = .none
    }
}
