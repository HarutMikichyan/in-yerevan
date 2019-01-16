//
//  ImagePickerCollectionViewCell.swift
//  In Yerevan
//
//  Created by Davit Ghushchyan on 12/29/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class ImagePickerCollectionViewCell: UICollectionViewCell {
    static let id = "ImagePickerCollectionViewCell"

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var checkMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.layer.masksToBounds = true
    }

    func changeCheckMarkStatus(isSelected: Bool) {
        checkMark.isHidden = isSelected
    }
}
