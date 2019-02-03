//
//  FirebaseEvent.swift
//  InYerevan
//
//  Created by Davit Ghushchyan on 1/11/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FirebaseEvent {
    
    let date: Date
    let details: String
    let pictureURLs: [String]
    let title: String
    let visitorsCount: Int
    let company: String
    let latitude: Double
    let longitude: Double
    let category: String
    
    init(date: Date, details: String, pictureURLs: [String], title: String, company: String, visitorsCount: Int, latitude: Double, longitude: Double, category: String) {
        self.date = date
        self.details = details
        self.pictureURLs = pictureURLs
        self.title = title
        self.visitorsCount = visitorsCount
        self.company = company
        self.latitude = latitude
        self.longitude = longitude
        self.category = category
    }
}

// MARK:- DATABASE REPRESENTATION

extension FirebaseEvent: DatabaseRepresentation {
    
    var representation: [String : Any] {
        return [
            "date": date,
            "details": details,
            "pictureURLs": pictureURLs,
            "title": title,
            "visitorsCount": visitorsCount,
            "company": company,
            "latitude": latitude,
            "longitude": longitude,
            "category": category,
        ]
    }
    
}
