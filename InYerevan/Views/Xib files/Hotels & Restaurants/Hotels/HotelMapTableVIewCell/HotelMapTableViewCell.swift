//
//  HotelMapTableViewCell.swift
//  In Yerevan
//
//  Created by HarutMikichyan on 12/23/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import MapKit

class HotelMapTableViewCell: UITableViewCell {
    
    static let id = "HotelMapTableViewCell"
    
    @IBOutlet weak var textMap: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
