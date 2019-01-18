//
//  HotelRestaurantImagePickerCollectionViewCell.swift
//  InYerevan
//
//  Created by HarutMikichyan on 1/14/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import UIKit

class HotelRestaurantImagePickerCollectionViewCell: UICollectionViewCell {
    static let id = "HotelRestaurantImagePickerCollectionViewCell"
    
    @IBOutlet weak var imagePicker: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imagePicker.layer.cornerRadius = 12
        imagePicker.clipsToBounds = true
    }
}
