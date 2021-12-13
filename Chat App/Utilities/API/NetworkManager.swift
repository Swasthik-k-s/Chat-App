//
//  NetworkManager.swift
//  Chat App
//
//  Created by Swasthik K S on 15/11/21.
//

import Foundation
//import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

struct NetworkManager {
    static let shared = NetworkManager()
    
    private let database = Database.database().reference()
    private let storage = Storage.storage()
    
    let databaseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    func login(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password,completion: completion)
    }
    
    func signup(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func resetPassword(email: String, completion: @escaping(String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(error.localizedDescription)
                return
            }
            completion("Sent")
        }
    }
    
    func addUser(user: UserData) {
        database.child("Users").child(user.uid).setValue(user.dictionary)
    }
    
    func fetchUser(completion: @escaping(UserData) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        database.child("Users").child(uid).observe(.value) { snapshot in
            if let dictionary = snapshot.value as? [String: Any] {
                let user = createUserObject(dictionary: dictionary)
                completion(user)
            }
        }
    }
    
    func fetchAllUsers(completion: @escaping([UserData]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var users = [UserData]()
        
        database.child("Users").observe(.value) { snapshot in
            if let result = snapshot.value as? [String: Any] {
                
                for userid in result.keys {
                    if userid == uid {
                        continue
                    }
                    let userData = result[userid] as! [String: Any]
                    let user = createUserObject(dictionary: userData)
                    users.append(user)
                }
                completion(users)
            }
        }
    }
    
    func addChat(users: [UserData], id: String, isGroupChat: Bool, groupName: String?, groupIconPath: String?) {
        var userDictionary: [[String: Any]] = []
        var finalDictionary: [String: Any]
        
        for user in users {
            userDictionary.append(user.dictionary)
        }
        if isGroupChat {
            finalDictionary = ["users": userDictionary,
                               "isGroupChat": isGroupChat,
                               "groupName": groupName!,
                               "groupIconPath": groupIconPath!]
        } else {
            finalDictionary = ["users": userDictionary,
                            "isGroupChat": isGroupChat]
        }
        
        database.child("Chats").child(id).setValue(finalDictionary)
    }
    
    func fetchChats(uid: String, completion: @escaping([Chats]) -> Void) {
        
        database.child("Chats").observe(.value) { snapshot in
            var chats = [Chats]()
            if let result = snapshot.value as? [String: [String: Any]] {
                
                for key in result.keys {
                    let value = result[key]!
                    var lastMessage: Message?
                    
                    let users = value["users"] as! [[String: Any]]
                    let lastMessageDictionary = value["lastMessage"] as? [String: Any]
                    let isGroupChat = value["isGroupChat"] as! Bool
                    
                    if lastMessageDictionary != nil {
                        
                        let sender = lastMessageDictionary!["sender"] as! String
                        let content = lastMessageDictionary!["content"] as! String
                        let timeString = lastMessageDictionary!["time"] as! String
                        let seen = lastMessageDictionary!["seen"] as! Bool
                        let imagePath = lastMessageDictionary!["imagePath"] as! String
                        
                        let time = databaseDateFormatter.date(from: timeString)
                        
                        lastMessage = Message(sender: sender, content: content, time: time!, seen: seen, imagePath: imagePath)
                        
                    } else {
                        lastMessage = nil
                    }
                    
                    var usersArray: [UserData] = []
                    var uidArray: [String] = []
                    let id = key
                    var chat: Chats
                    
                    for user in users {
                        let userObject = createUserObject(dictionary: user)
                        usersArray.append(userObject)
                        uidArray.append(userObject.uid)
                    }
                    
                    if isGroupChat {
                        let groupName = value["groupName"] as! String
                        let groupIconPath = value["groupIconPath"] as! String
                        
                        chat = Chats(chatId: id, users: usersArray, lastMessage: lastMessage, messages: [], isGroupChat: isGroupChat, groupName: groupName, groupIconPath: groupIconPath)
                        
                    } else {
                        var otherUser: Int
                        if usersArray[0].uid == uid {
                            otherUser = 1
                        } else {
                            otherUser = 0
                        }
                        
                        chat = Chats(chatId: id, users: usersArray, lastMessage: lastMessage, messages: [], otherUser: otherUser, isGroupChat: isGroupChat)
                    }
                    
                    if uidArray.contains(uid) {
                        chats.append(chat)
                    }
                }
                let sortedChats = chats.sorted()
                completion(sortedChats)
            }
        }
    }
    
    func fetchMessages(chatId: String, completion: @escaping([Message]) -> Void) {
        
        database.child("Chats").child("\(chatId)/messages").observe(.value) { snapshot in
            var resultArray: [Message] = []
            if let result = snapshot.value as? [String: [String: Any]] {
                
                let sortedKeyArray = result.keys.sorted()
                for id in sortedKeyArray {
                    let message = result[id]!
                    let messageObject = createMessageObject(dictionary: message , id: id)
                    resultArray.append(messageObject)
                }
                completion(resultArray)
            }
        }
    }
    
    func addMessage(lastMessage: Message, id: String) {
        
        var lastMessageItem = lastMessage
        
        let dateString = databaseDateFormatter.string(from: lastMessageItem.time)
        lastMessageItem.dateString = dateString
        
        let lastMessageDictionary = lastMessageItem.dictionary
        let finalDictionary = ["lastMessage": lastMessageDictionary]
        
        database.child("Chats").child(id).updateChildValues(finalDictionary)
        database.child("Chats").child(id).child("messages").childByAutoId().setValue(lastMessageDictionary)
    }
    
    func downloadImage(url: String, completion: @escaping(UIImage) -> Void) {
        let result = storage.reference(forURL: url)
        result.getData(maxSize: 1 * 1024 * 1024) { data, error in
            guard error == nil else { return }
            if let data = data {
                let resultImage: UIImage! = UIImage(data: data)
                completion(resultImage)
            }
        }
    }
    
    func downloadImageWithPath(path: String, completion: @escaping(UIImage) -> Void) {
        let result = storage.reference(withPath: path)
        result.getData(maxSize: 1 * 1024 * 1024) { data, error in
            guard error == nil else { return }
            if let data = data {
                let resultImage: UIImage! = UIImage(data: data)
                completion(resultImage)
            }
        }
    }
    
    func getUID() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func signout() -> Bool {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            return true
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        return false
    }
    
    func createMessageObject(dictionary: [String: Any], id: String) -> Message {
        let sender = dictionary["sender"] as! String
        let content = dictionary["content"] as! String
        let timeString = dictionary["time"] as! String
        let seen = dictionary["seen"] as! Bool
        let imagePath = dictionary["imagePath"] as! String
        let time = databaseDateFormatter.date(from: timeString)
        
        return Message(sender: sender, content: content, time: time!, seen: seen, imagePath: imagePath, id: id)
    }
    
    func createUserObject(dictionary: [String: Any]) -> UserData {
        let email = dictionary["email"] as! String
        let username = dictionary["username"] as! String
        let uid = dictionary["uid"] as! String
        let profileURL = dictionary["profileURL"] as! String
        
        return UserData(username: username, email: email, profileURL: profileURL, uid: uid)
    }
}
