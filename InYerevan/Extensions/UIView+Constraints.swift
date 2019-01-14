//
//  UIView+Constraints.swift
//  InYerevan
//
//  Created by Vahram Tadevosian on 1/14/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addConstraints(equalToConstraintsOf view: UIView, withTrailingConstant: CGFloat, leadingConstant: CGFloat, bottomConstant: CGFloat, topConstant: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: withTrailingConstant))
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: leadingConstant))
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: bottomConstant))
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: topConstant))
    }
    
    func addConstraints(equalToConstraintsOf view: UIView, withHeightMultiplier: CGFloat, widthMultiplier: CGFloat, centerXMultiplier: CGFloat, centerYMultiplier: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: withHeightMultiplier, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: widthMultiplier, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: centerXMultiplier, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: centerYMultiplier, constant: 0))
    }
}

