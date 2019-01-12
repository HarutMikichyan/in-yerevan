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
    
//    init?(document: QueryDocumentSnapshot) {
//        let data = document.data()
//        guard let date = data["date"] as? Date else {return nil}
//        guard let details = data["details"] as? String else {return nil}
//        guard let pictureURLs = data["pictureURL"] as? [String] else {return nil}
//        guard let title = data["title"] as? String else {return nil}
//        guard let visitorsCount = data["visitorsCount"] as? Int else {return nil}
//        guard let company = data["company"] as? String  else {return nil}
//        guard let latitude = data["latitude"] as? Double else {return nil}
//        guard let longitude = data["longitude"] as? Double else {return nil}
//        
//        self.date = date 
//        self.details = details
//        self.pictureURLs = pictureURLs
//        self.title = title
//        self.visitorsCount = visitorsCount
//        self.company = company
//        self.latitude = latitude
//        self.longitude = longitude
//    }
//        
}

// MARK:- DATABASE REPRESENTATION

extension FirebaseEvent: DatabaseRepresentation {
    
    var representation: [String : Any] {
        let rep: [String : Any] = [
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
        
        return rep
    }
    
}
