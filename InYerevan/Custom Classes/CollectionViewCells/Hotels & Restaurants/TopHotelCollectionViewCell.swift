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
    
    @IBOutlet weak var topHotelsImage: UIImageView!
    @IBOutlet weak var topHotelsName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topHotelsImage.layer.cornerRadius = 12
        topHotelsImage.clipsToBounds = true
    }
}
