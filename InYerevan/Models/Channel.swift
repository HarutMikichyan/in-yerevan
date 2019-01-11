//
//  Channel.swift
//  In Yerevan
//
//  Created by Vahram Tadevosian on 12/25/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import FirebaseFirestore

protocol DatabaseRepresentation {
    var representation: [String: Any] { get }
}

struct Channel {
    
    // MARK:- MAIN PROPERTIES
    
    let id: String?
    let name: String
    var numberOfUnreadMessages: Int
    var lastMessageSentDate: Date
    
    // MARK:- INITIALIZERS
    
    init(name: String) {
        id = nil
        self.name = name
        numberOfUnreadMessages = 0
        lastMessageSentDate = Date()
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let name = data["name"] as? String else { return nil }
        guard let sentDate = data["lastMessageSent"] as? Date else { return nil }
        guard let unreadMessages = data["unreadMessages"] as? Int else { return nil }
        
        id = document.documentID
        self.name = name
        self.numberOfUnreadMessages = unreadMessages
        self.lastMessageSentDate = sentDate
    }
    
}

// MARK:- DATABASE REPRESENTATION

extension Channel: DatabaseRepresentation {
    
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "name": name,
            "unreadMessages": numberOfUnreadMessages,
            "lastMessageSent": lastMessageSentDate
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
