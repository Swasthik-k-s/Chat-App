//
//  UserData.swift
//  Chat App
//
//  Created by Swasthik K S on 16/11/21.
//

import Foundation

struct UserData {
    var username: String
    var email: String
    var profileURL: String
    var uid: String
    
    var dictionary: [String: Any] {
        return [
            "username": username,
            "email": email,
            "profileURL": profileURL,
            "uid": uid
        ]
    }
}
