//
//  UpcommingTableViewCell.swift
//  In Yerevan
//
//  Created by Davit Ghushchyan on 12/16/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {
    
static let id = "UpcomingTableViewCell"
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var whenLabel: UILabel!
    @IBOutlet weak var blur: UIVisualEffectView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        blur.layer.cornerRadius = 12
        blur.layer.masksToBounds = true
        backgroundImageView.layer.cornerRadius = 12
        backgroundImageView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {    
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: -7, left: 0, bottom: -7, right: 0))
    }
    
    func prepareCellWith(label: String, background: UIImage) {
        backgroundImageView.image = background
        whenLabel.text = label
    } 

}
