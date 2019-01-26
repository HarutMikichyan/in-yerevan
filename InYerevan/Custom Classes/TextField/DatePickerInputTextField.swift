//
//  DatePickerInputTextField.swift
//  In Yerevan
//
//  Created by Davit Ghushchyan on 12/24/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class DatePickerInputTextField: UITextField {
    // MARK: - Variables
    private let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 0, height: 280))
    
    // MARK: - Initializers 
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    // MARK: - Prepareing for init
    private func prepare() {
        disableUserManuallyInput()
        inputView = datePicker
        let doneButton = DoneButton()
        
        doneButton.addTarget(self, action: #selector(endEditing(_:)), for: .touchUpInside)
        inputAccessoryView = doneButton
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date() + (60 * 60 * 24 * 30 * 2) // (secs , mins , hrs, days, months)
        datePicker.addTarget(self, action: #selector(valueChange), for: .valueChanged)
    }
    
    private func  disableUserManuallyInput() {
        autocapitalizationType = .none
        autocorrectionType = .no
        smartDashesType = .no
        smartInsertDeleteType = .no
        smartQuotesType = .no
        spellCheckingType = .no
    }
    
    @objc private func valueChange() {
       let dateAsString = datePicker.date.toString()
        text = "\(dateAsString.day) \(dateAsString.month) \(dateAsString.year) \(dateAsString.time)"
    }
    
    // MARK: - Public 
    func getValue() -> Date {
        return datePicker.date
    }
    
    func setTommorow() {
        datePicker.date = Date() + (60 * 60 * 24 ) // (sec * min * hrs ) to get tomorrow 
        let dateAsString = datePicker.date.toString()
        text = "\(dateAsString.day) \(dateAsString.month) \(dateAsString.year) \(dateAsString.time)"
    }
    
}
