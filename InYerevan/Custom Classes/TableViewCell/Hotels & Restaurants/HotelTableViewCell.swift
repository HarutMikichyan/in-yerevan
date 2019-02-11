//
//  HotelTableViewCell.swift
//  InYerevan
//
//  Created by HarutMikichyan on 1/9/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import UIKit

class HotelTableViewCell: UITableViewCell {
    static let id = "HotelTableViewCell"
    
    @IBOutlet weak var imageHotel: UIImageView!
    @IBOutlet weak var nameHotel: UILabel!
    @IBOutlet weak var starHotel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageHotel.layer.cornerRadius = 12
        imageHotel.clipsToBounds = true
        selectionStyle = .none
    }
}
