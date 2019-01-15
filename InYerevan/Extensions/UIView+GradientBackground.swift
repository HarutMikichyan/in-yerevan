//
//  UIView+GradientBackground.swift
//  InYerevan
//
//  Created by Vahram Tadevosian on 1/14/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func changeBackgroundToGradient(from colors: [UIColor]) {
        if colors.count == 0 { return }
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        var gradientColors = [CGColor]()
        for color in colors {
            gradientColors.append(color.cgColor)
        }
        gradient.colors = gradientColors
        self.layer.insertSublayer(gradient, at: 0)
    }
}
