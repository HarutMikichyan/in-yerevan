//
//  Message.swift
//  In Yerevan
//
//  Created by Vahram Tadevosian on 12/25/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import Firebase
import FirebaseFirestore
import MessageKit

struct Message: MessageType {
    
    // MARK:- MAIN PROPERTIES
    
    let id: String?
    let content: String
    let sentDate: Date
    let sender: Sender
    
    var emoji: String? = nil
    var image: UIImage? = nil
    var downloadURL: URL? = nil
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var kind: MessageKind {
        if let image = image {
            return .photo(Image(image: image))
        }
        
        if let content = emoji {
            return .emoji(content)
        }
        
        return .text(content)
    }
    
    // MARK:- INITIALIZERS
    
    init(content: String) {
        sender = Sender(id: User.email, displayName: ChatSettings.displayName)
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    init(image: UIImage) {
        sender = Sender(id: User.email, displayName: ChatSettings.displayName)
        self.image = image
        content = ""
        sentDate = Date()
        id = nil
    }
    
    init(emoji: String) {
        sender = Sender(id: User.email, displayName: ChatSettings.displayName)
        self.emoji = emoji
        content = emoji
        sentDate = Date()
        id = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let sentDate = data["created"] as? Date else {
            return nil
        }
        guard let senderID = data["senderID"] as? String else {
            return nil
        }
        guard let senderName = data["senderName"] as? String else {
            return nil
        }
        
        id = document.documentID
        self.sentDate = sentDate
        sender = Sender(id: senderID, displayName: senderName)
        if let content = data["content"] as? String {
            self.content = content
            downloadURL = nil
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
            content = ""
        } else {
            return nil
        }
    }
    
}

// MARK:- DATABASE REPRESENTATION

extension Message: DatabaseRepresentation {
    
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "created": sentDate,
            "senderID": sender.id,
            "senderName": sender.displayName
        ]
        
        if let url = downloadURL {
            rep["url"] = url.absoluteString
        } else {
            rep["content"] = content
        }
        return rep
    }
    
}

// MARK:- COMPARABILITY

extension Message: Comparable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
}
