//
//  TopHotelCollectionViewCell.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/19/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class TopHotelCollectionViewCell: UICollectionViewCell {
    
    static let id = "TopHotelCollectionViewCell"
    
    @IBOutlet weak var topHotelImage: UIImageView!
    @IBOutlet weak var topHotelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topHotelImage.layer.cornerRadius = 12
        topHotelImage.clipsToBounds = true
    }
}
