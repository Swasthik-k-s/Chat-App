//
//  ChatItem.swift
//  Chat App
//
//  Created by Swasthik K S on 15/11/21.
//

import Foundation

struct Chats {
    var users: [UserData]
    var lastMessage: Message?
    var messages: [Message]?
    var otherUser: Int?
    
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
