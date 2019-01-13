//
//  ViewController.swift
//  InYerevan
//
//  Created by Vahram Tadevosian on 1/13/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var stack: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view!.addSubview(bg)
        bg.translatesAutoresizingMaskIntoConstraints = false
        
        
        let constant = bg.bounds.width - (0.18 * bg.bounds.width)
        
        view.addConstraint(NSLayoutConstraint(item: bg, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: constant))
        
        view.addConstraint(NSLayoutConstraint(item: bg, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: bg, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: bg, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        
        view!.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addConstraint(NSLayoutConstraint(item: stack, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.25, constant: 0))

        view.addConstraint(NSLayoutConstraint(item: stack, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.45, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: stack, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.5, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: stack, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.8, constant: 0))
        
        let spacing = stack.bounds.height * 0.1
        stack.spacing = spacing
    }
    

}
