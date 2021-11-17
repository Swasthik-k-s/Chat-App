//
//  ImageUploader.swift
//  Chat App
//
//  Created by Swasthik K S on 16/11/21.
//

import Foundation
import UIKit
import FirebaseStorage

struct ImageUploader {
    static func uploadImage(image: UIImage, uid: String, completion: @escaping(String) -> Void) {
        
        let storage = Storage.storage().reference()
        
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        
        storage.child("Profile").child(uid).putData(imageData, metadata: nil) { _, error in
            guard error == nil else { return }
            
            storage.child("Profile").child(uid).downloadURL { url, error in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                
                print("Download URL: \(urlString)")
                completion(urlString)
//                UserDefaults.standard.set(urlString, forKey: "url")
            }
        }
    }
}
