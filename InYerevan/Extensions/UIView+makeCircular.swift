//
//  UIView+makeCircular.swift
//  InYerevan
//
//  Created by Vahram Tadevosian on 1/15/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.clipsToBounds = true
    }
    
    func addBlurredSubview(_ blurredSubview: UIVisualEffectView) {
        blurredSubview.frame = self.bounds
        blurredSubview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurredSubview)
    }
}
