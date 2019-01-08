//
//  TopRestaurantCollectionViewCell.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/19/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class TopRestaurantCollectionViewCell: UICollectionViewCell {
    
    static let id = "TopRestaurantCollectionViewCell"
    
    @IBOutlet weak var topRestaurantImage: UIImageView!
    @IBOutlet weak var topRestaurantName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topRestaurantImage.layer.cornerRadius = 12
        topRestaurantImage.clipsToBounds = true
    }
}
