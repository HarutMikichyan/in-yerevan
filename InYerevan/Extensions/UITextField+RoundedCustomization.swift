//
//  UITextField+RoundedCustomization.swift
//  InYerevan
//
//  Created by Vahram Tadevosian on 1/14/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func customize(by view: UIView, placeholder: String) {
        let cornerRadius = view.bounds.height / 45
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: cornerRadius / 2, height: self.bounds.height))
        let height = view.bounds.height / 50
        let font = UIFont.init(name: (self.font?.fontName)!, size: height)!
        let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderWhite])

        self.adjustsFontSizeToFitWidth = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.leftView = paddingView
        self.leftViewMode = .always
        self.font = font
        self.attributedPlaceholder = attributedPlaceholder
    }
}
