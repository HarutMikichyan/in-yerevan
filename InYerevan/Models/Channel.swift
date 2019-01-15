//
//  Channel.swift
//  In Yerevan
//
//  Created by Vahram Tadevosian on 12/25/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import Firebase
import FirebaseFirestore

protocol DatabaseRepresentation {
    var representation: [String: Any] { get }
}

class Channel {
    
    // MARK:- MAIN PROPERTIES
    
    let id: String?
    let name: String
    var isUnseenBySupport: Bool
    var lastMessageSentDate: Date
    var lastMessagePreview: String
    let sentByAdministration: Bool
    
    // MARK:- INITIALIZERS
    
    init(name: String) {
        id = nil
        self.name = name
        isUnseenBySupport = true
        lastMessageSentDate = Date()
        lastMessagePreview = ""
        sentByAdministration = User.isAdministration
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let name = data["name"] as? String else { return nil }
        guard let sentDate = data["lastMessageSent"] as? Date else { return nil }
        guard let unseenBySupport = data["unseen"] as? Bool else { return nil }
        guard let lastMessage = data["lastMessage"] as? String else { return nil }
        guard let sentByAdministration = data["sentByAdministration"] as? Bool else { return nil }

        id = document.documentID
        self.name = name
        self.isUnseenBySupport = unseenBySupport
        self.lastMessageSentDate = sentDate
        self.lastMessagePreview = lastMessage
        self.sentByAdministration = sentByAdministration
    }
    
}

// MARK:- DATABASE REPRESENTATION

extension Channel: DatabaseRepresentation {
    
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "name": name,
            "unseen": isUnseenBySupport,
            "lastMessageSent": lastMessageSentDate,
            "lastMessage": lastMessagePreview,
            "sentByAdministration" : sentByAdministration
        ]
        
        if let id = id {
            rep["id"] = id
        }
        return rep
    }
    
}

// MARK:- COMPARABILITY

extension Channel: Comparable {
    
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func < (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.lastMessageSentDate > rhs.lastMessageSentDate
    }
    
}
