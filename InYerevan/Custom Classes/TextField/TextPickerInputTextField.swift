//
//  TextPickerInputTextField.swift
//  InYerevan
//
//  Created by Davit Ghushchyan on 1/15/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import UIKit

protocol TextPickerInputTextFieldDelegate: class {
    func didSelectedRowWith(title: String)
}

class TextPickerInputTextField: UITextField {
    
    weak var pickerDelegate: TextPickerInputTextFieldDelegate?
    // MARK: - Private Interface 
    private let picker = UIPickerView()
    
    // MARK: - Public Interface 
    
    var rowContents = [String]()
    
    private(set) var value: String! {
        willSet {
           text = newValue 
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    // MARK: - Prepareing for init 
    private func configure() {
        inputView = picker
        picker.delegate = self
        let doneButton = DoneButton()
        doneButton.addTarget(self, action: #selector(endEditing(_:)), for: .touchUpInside)
        inputAccessoryView = doneButton
    }
   
    
}


extension TextPickerInputTextField: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rowContents.count
    }
     
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return rowContents[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerDelegate?.didSelectedRowWith(title: rowContents[row])
        value = rowContents[row]
    }
    
}
