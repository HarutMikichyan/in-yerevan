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
    
    let id: String?
    let name: String
    var numberOfUnreadMessages: Int?
    
    init(name: String) {
        id = nil
        self.name = name
        numberOfUnreadMessages = 0
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let name = data["name"] as? String else {
            return nil
        }
        id = document.documentID
        self.name = name
        numberOfUnreadMessages = data["unreadMessages"] as? Int ?? 0
    }
    
}

// MARK:- DATABASE REPRESENTATION

extension Channel: DatabaseRepresentation {
    
    var representation: [String : Any] {
        var rep = ["name": name, "unreadMessages": numberOfUnreadMessages ?? 0] as [String : Any]
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
        return lhs.name < rhs.name
    }
    
}
