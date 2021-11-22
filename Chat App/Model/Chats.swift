//
//  ChatItem.swift
//  Chat App
//
//  Created by Swasthik K S on 15/11/21.
//

import Foundation

struct Chats: Comparable {
    static func == (lhs: Chats, rhs: Chats) -> Bool {
        return true
    }
    
    static func < (lhs: Chats, rhs: Chats) -> Bool {
        guard let lastMessageLHS = lhs.lastMessage else {
            return false
        }
        guard let lastMessageRHS = rhs.lastMessage else {
            return true
        }
        if lastMessageLHS.time < lastMessageRHS.time.addingTimeInterval(10) {
            return false
        } else {
            return true
        }
    }
    
    var chatId: String?
    var users: [UserData]
    var lastMessage: Message?
    var messages: [Message]?
    var otherUser: Int?
    var unSeenCount: Int?
    
//    var userDictionary: {
//        return [
//            "username": users[],
//            "email": email,
//            "profileURL": profileURL,
//            "uid": uid
//        ]
//    }
//    var dictionary: [String: Any] {
//        return [
//            "users": userDictionary,
//            "lastMessage": lastMessage ?? Message(sender: "", content: "", time: nil, seen: nil),
//            "messages": messages ?? [Message](),
//        ]
//    }
}
