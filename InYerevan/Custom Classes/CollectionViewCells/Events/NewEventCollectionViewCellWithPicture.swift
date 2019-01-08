//
//  NewEventCollectionViewCellWithPicture.swift
//  In Yerevan
//
//  Created by Davit Ghushchyan on 12/21/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

protocol NewEventCollectionViewCellWithPictureDelegate: class {
    func didDeleteCell(with indexPath: IndexPath)
}

class NewEventCollectionViewCellWithPicture: UICollectionViewCell {
    static let id = "NewEventCollectionViewCellWithPicture"
    
    private var indexPath: IndexPath!
    @IBOutlet weak var imageView: UIImageView!
    weak var delegate: NewEventCollectionViewCellWithPictureDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func prepareCellWith(indexPath: IndexPath, image: UIImage?) {
        imageView.image = image
        self.indexPath = indexPath
    } 
    
    
    @IBAction func deleteAction() {
        let vibration = UIImpactFeedbackGenerator(style: .heavy)
        vibration.impactOccurred()
        delegate?.didDeleteCell(with: indexPath)
    }
}
