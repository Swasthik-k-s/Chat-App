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
    
    func addUser(user: UserData) {
        database.child("Users").child(user.uid).setValue(user.dictionary)
    }
    
    func fetchUser(uid: String, completion: @escaping(UserData) -> Void) {
        database.child("Users").child(uid).observe(.value) { snapshot in
            if let dictionary = snapshot.value as? [String: Any] {
                
//                print(dictionary)
                let email = dictionary["email"] as! String
                let username = dictionary["username"] as! String
                let profileURL = dictionary["profileURL"] as! String
                let uid = dictionary["uid"] as! String

                let user = UserData(username: username, email: email, profileURL: profileURL, uid: uid)
                completion(user)
            }
        }
    }
    
    func fetchAllUsers(uid: String, completion: @escaping([UserData]) -> Void) {
        print("wdwewedwef")
        
        var users = [UserData]()
        
        database.child("Users").observe(.value) { snapshot in
            if let result = snapshot.value as? [String: Any] {
//                print(result)
                for userid in result.keys {
                    if userid == uid {
                        continue
                    }
                    let userData = result[userid] as! [String: Any]
                    
                    let email = userData["email"] as! String
                    let username = userData["username"] as! String
                    let uid = userData["uid"] as! String
                    let profileURL = userData["profileURL"] as! String
                    let user = UserData(username: username, email: email, profileURL: profileURL, uid: uid)
                    users.append(user)
                }
                completion(users)
            }
        }
        
    }
    
    func addChat(user1: UserData, user2: UserData, id: String) {
        var userDictionary: [[String: Any]] = []
        
        userDictionary.append(user1.dictionary)
        userDictionary.append(user2.dictionary)
        let finalDic = ["users" : userDictionary]

        database.child("Chats").child(id).setValue(finalDic)
    }
    
    func fetchChats(uid: String, completion: @escaping([Chats]) -> Void) {
        
        database.child("Chats").observe(.value) { snapshot in
            var chats = [Chats]()
            print("//////////////////////////")
            if let result = snapshot.value as? [String: [String: Any]] {
//                print(result)
                for key in result.keys {
//                   print(keys)
                    let value = result[key]!
                    var messagesArray: [Message] = []
                    var lastMessage: Message?
                    
                    let users = value["users"] as! [[String: Any]]
                    let lastMessageDictionary = value["lastMessage"] as? [String: Any]
                    let messagesDictionary = value["messages"] as? [[String: Any]]
//                    print(users)
                    if lastMessageDictionary != nil {
                        for messageItem in messagesDictionary! {
                            let sender = messageItem["sender"] as! String
                            let content = messageItem["content"] as! String
                            let timeString = messageItem["time"] as! String
                            let seen = messageItem["seen"] as! Bool
                            
                            let time = databaseDateFormatter.date(from: timeString)
                            
                            let currentMessage = Message(sender: sender, content: content, time: time!, seen: seen)
                            
                            messagesArray.append(currentMessage)
                        }
                        
                        let sender = lastMessageDictionary!["sender"] as! String
                        let content = lastMessageDictionary!["content"] as! String
                        let timeString = lastMessageDictionary!["time"] as! String
                        let seen = lastMessageDictionary!["seen"] as! Bool
                        
                        let time = databaseDateFormatter.date(from: timeString)
                        
                        lastMessage = Message(sender: sender, content: content, time: time!, seen: seen)
                        
                    } else {
                        messagesArray = []
                        lastMessage = nil
                    }
                    
                    let user1 = users[0]
                    let user2 = users[1]
                    
                    let email1 = user1["email"] as! String
                    let username1 = user1["username"] as! String
                    let uid1 = user1["uid"] as! String
                    let profileURL1 = user1["profileURL"] as! String
                    
                    let firstUser = UserData(username: username1, email: email1, profileURL: profileURL1, uid: uid1)
                    
                    let email2 = user2["email"] as! String
                    let username2 = user2["username"] as! String
                    let uid2 = user2["uid"] as! String
                    let profileURL2 = user2["profileURL"] as! String
                    
                    let secondUser = UserData(username: username2, email: email2, profileURL: profileURL2, uid: uid2)
                    
                    var otherUser: Int
                    
                    if uid1 == uid {
                        otherUser = 1
                    } else {
                        otherUser = 0
                    }
                    let id = key
                    
                    let chat = Chats(chatId: id, users: [firstUser, secondUser], lastMessage: lastMessage, messages: messagesArray, otherUser: otherUser)
                    
                    if firstUser.uid == uid || secondUser.uid == uid {
                        chats.append(chat)
                    }
                }
                completion(chats)
            }
        }
    }
    
    func fetchMessages(chatId: String, completion: @escaping([Message]) -> Void) {
        database.child("Chats").child("\(chatId)/messages").observe(.value) { snapshot in
            var resultArray: [Message] = []
            
            if let result = snapshot.value as? [[String: Any]] {
//                print("Result\(result)")
                for message in result {
//                    print("Messages\(message)")
                    resultArray.append(createMessageObject(dictionary: message))
                }
                
                completion(resultArray)
            }
        }
    }
    
    func addMessage(chat: Chats, id: String) {
        
        var currentChat = chat
        
        let dateString = databaseDateFormatter.string(from: currentChat.lastMessage!.time)
        currentChat.lastMessage?.dateString = dateString
        
        let lastMessageDictionary = currentChat.lastMessage?.dictionary
        var messagesDictionary: [[String: Any]] = []
        
        for var message in currentChat.messages! {
            let dateString = databaseDateFormatter.string(from: message.time)
            message.dateString = dateString
            messagesDictionary.append(message.dictionary)
        }
//        userDictionary.append(user1.dictionary)
//        userDictionary.append(user2.dictionary)
        let finalDictionary = ["lastMessage": lastMessageDictionary!,
                               "messages": messagesDictionary] as [String : Any]
//        database.child("Chats").child(id).setValue(finalDictionary)
        database.child("Chats").child(id).updateChildValues(finalDictionary)
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
    
    func createMessageObject(dictionary: [String: Any]) -> Message {
        let sender = dictionary["sender"] as! String
        let content = dictionary["content"] as! String
        let timeString = dictionary["time"] as! String
        let seen = dictionary["seen"] as! Bool
        
        let time = databaseDateFormatter.date(from: timeString)
        
        return Message(sender: sender, content: content, time: time!, seen: seen)
    }
}
