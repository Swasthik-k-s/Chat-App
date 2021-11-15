//
//  Constants.swift
//  Chat App
//
//  Created by Swasthik K S on 13/11/21.
//

import Foundation
import UIKit

struct ColorConstants {
    
    static let lightGreen = UIColor(red: 37/255.0, green: 211/255.0, blue: 102/255.0, alpha: 1.0)
    static let tealGreen = UIColor(red: 18/255.0, green: 140/255.0, blue: 126/255.0, alpha: 1.0)
    static let darkTealGreen = UIColor(red: 7/255.0, green: 94/255.0, blue: 84/255.0, alpha: 1.0)
}

struct FontConstants {
    static let bold1 = UIFont.systemFont(ofSize: 16, weight: .bold)
    static let bold2 = UIFont.systemFont(ofSize: 18, weight: .bold)
    static let bold3 = UIFont.systemFont(ofSize: 20, weight: .bold)
    
    static let normal1 = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let normal2 = UIFont.systemFont(ofSize: 18, weight: .medium)
    static let normal3 = UIFont.systemFont(ofSize: 20, weight: .medium)
}

struct ImageConstants {
    static let mail = UIImage(systemName: "envelope.fill")
    static let person = UIImage(systemName: "person.fill")
    static let appIcon = UIImage(systemName: "message.circle.fill")
    
}
