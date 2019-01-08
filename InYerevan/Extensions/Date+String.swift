//
//  Date+String.swift
//  In Yerevan
//
//  Created by Davit Ghushchyan on 12/17/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

extension Date {
    
    // return tuple of Date as (YYYY, MMM, DD, HH, MM )
    func dateToString() -> (year: String, month: String, day: String, time: String ) {
        let _ = "2018-12-16 10:11:16 PM +0000"
        let stringDate = description
        let year = stringDate.components(separatedBy: "-").first!
        var month = stringDate.components(separatedBy: "-")[1]
        let day = stringDate.components(separatedBy: "-").last!.components(separatedBy: " ").first!
        let dateFormeter = DateFormatter()
        dateFormeter.dateFormat = "HH:mm"
        let time = dateFormeter.string(from: self)
        //replace digit with MMM
        switch month {
        case "01": 
            month = "Jan"
        case "02":
            month = "Feb"
        case "03":
            month = "Mar"
        case "04":
            month = "Apr"
        case "05":
            month = "May"
        case "06":
            month = "Jun"
        case "07":
            month = "Jul"
        case "08":
            month = "Aug"
        case "09":
            month = "Sep"
        case "10":
            month = "Ouc"
        case "11":
            month = "Nov"
        case "12":
            month = "Dec"
        default:
            break
        }
        
        return (year, month, day, time)
    }
}
