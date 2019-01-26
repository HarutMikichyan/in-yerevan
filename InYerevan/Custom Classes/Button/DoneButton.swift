//
//  DoneButton.swift
//  In Yerevan
//
//  Created by Davit Ghushchyan on 12/29/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class DoneButton: UIButton {
    
    // MARK: - Initializators
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepare()
    }
    
    //MARK: - Prepare Button 
    private func prepare() { 
        frame = CGRect(x: 0, y: 0, width: 0, height: 35)
        setTitle("Done", for: .normal)
        tintColor = .white
        backgroundColor = .outgoingLavender
    }
    
}
