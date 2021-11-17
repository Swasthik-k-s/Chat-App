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
                let email = dictionary["email"] as! String
                let username = dictionary["username"] as! String
                let profileURL = dictionary["profileURL"] as! String
                let uid = dictionary["uid"] as! String
                
                let user = UserData(username: username, email: email, profileURL: profileURL, uid: uid)
                completion(user)
            }
        }
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
}
