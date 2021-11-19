//
//  UserData.swift
//  Chat App
//
//  Created by Swasthik K S on 16/11/21.
//

import Foundation

//class UserData: NSObject {
//    var username: String?
//    var email: String?
//    var profileURL: String?
//    var uid: String?
    
//    init(username: String, email: String, profileURL: String, uid: String) {
//        super.init()
//        self.username = username
//        self.email = email
//        self.profileURL = profileURL
//        self.uid = uid
//    }
    
//    var dictionary: [String: Any] {
//        return [
//            "username": username!,
//            "email": email!,
//            "profileURL": profileURL!,
//            "uid": uid!
//        ]
//    }
//}

struct UserData: Codable {

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
