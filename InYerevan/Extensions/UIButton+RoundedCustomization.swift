//
//  UIButton+RoundedCustomization.swift
//  InYerevan
//
//  Created by Vahram Tadevosian on 1/14/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func customize(by view: UIView, shouldBeRound: Bool) {
        let size = view.bounds.height / 50
        let fontRounded = UIFont.init(name: ((self.titleLabel?.font.fontName)!), size: size)!
        let fontRegular = UIFont.init(name: ((self.titleLabel?.font.fontName)!), size: size - 0.6)!
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if shouldBeRound {
            let cornerRadius = view.bounds.height / 45
            self.layer.cornerRadius = cornerRadius
            self.titleLabel?.font = fontRounded
        } else {
            self.titleLabel?.font = fontRegular
        }
    }
    
}
