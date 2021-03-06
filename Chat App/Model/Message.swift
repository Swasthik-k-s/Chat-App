//
//  Message.swift
//  Chat App
//
//  Created by Swasthik K S on 17/11/21.
//

import Foundation
import UIKit

struct Message {
    var sender: String
    var content: String
    var time: Date
    var seen: Bool
    var dateString: String?
    var imagePath: String
    var image: UIImage?
    var id: String?
    
    var dictionary: [String: Any] {
        return [
            "sender": sender,
            "content": content,
            "time": dateString!,
            "seen": seen,
            "imagePath": imagePath
        ]
    }
    
    
}
