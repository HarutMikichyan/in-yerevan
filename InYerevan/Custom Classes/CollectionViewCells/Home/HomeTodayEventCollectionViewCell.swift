//
//  HomeTodayEventCollectionViewCell.swift
//  InYerevan
//
//  Created by Gev Darbinyan on 28/01/2019.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import UIKit

class HomeTodayEventCollectionViewCell: UICollectionViewCell {
  
    @IBOutlet weak var todayEventImage: UIImageView!
    @IBOutlet weak var todayEentName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        todayEventImage.layer.cornerRadius = 12
        todayEventImage.clipsToBounds = true
    }
}
