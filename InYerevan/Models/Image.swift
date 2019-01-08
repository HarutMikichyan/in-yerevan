//
//  Image.swift
//  In Yerevan
//
//  Created by Vahram Tadevosian on 12/27/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

struct Image: MediaItem {
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
    
}
