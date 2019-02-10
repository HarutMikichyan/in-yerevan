//
//  HotelRestaurantCollectionViewCell.swift
//  InYerevan
//
//  Created by HarutMikichyan on 1/10/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import UIKit

class HotelRestaurantCollectionViewCell: UICollectionViewCell {
    static let id = "HotelRestaurantCollectionViewCell"
    
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
    }
}
