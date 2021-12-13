//
//  Constants.swift
//  Chat App
//
//  Created by Swasthik K S on 13/11/21.
//

import Foundation
import UIKit

struct ColorConstants {
    
//    static let dimTealGreen = UIColor(red: 18/255.0, green: 140/255.0, blue: 126/255.0, alpha: 0.5)
//    static let darkTealGreen = UIColor(red: 7/255.0, green: 94/255.0, blue: 84/255.0, alpha: 1.0)
    static let blue = UIColor(red: 52/255.0, green: 183/255.0, blue: 241/255.0, alpha: 1.0)
    static let customWhite = UIColor(red: 236/255.0, green: 229/255.0, blue: 221/255.0, alpha: 1.0)
    static let grey = UIColor(red: 67/255.0, green: 90/255.0, blue: 100/255.0, alpha: 1.0)
//    static let view = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
//    static let white = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)

    static let customRed = UIColor(red: 234/255.0, green: 60/255.0, blue: 83/255.0, alpha: 1.0)
    static let navBar = UIColor(red: 0.137, green: 0.176, blue: 0.212, alpha: 1)
    static let navBarTitle = UIColor(red: 0.616, green: 0.647, blue: 0.675, alpha: 1)
    static let icon = UIColor(red: 0.98, green: 1, blue: 1, alpha: 1)
    static let viewBackground = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)
    static let lightGreen = UIColor(red: 0, green: 0.69, blue: 0.612, alpha: 1)
    static let titleText = UIColor(red: 0.827, green: 0.855, blue: 0.878, alpha: 1)
    static let labelText = UIColor(red: 0.525, green: 0.561, blue: 0.58, alpha: 1)
    static let popupView = UIColor(red: 0.192, green: 0.235, blue: 0.259, alpha: 1)
    static let textField = UIColor(red: 0.176, green: 0.22, blue: 0.243, alpha: 1)
    static let green = UIColor(red: 0.008, green: 0.678, blue: 0.608, alpha: 1)
    static let tealGreen = UIColor(red: 18/255.0, green: 140/255.0, blue: 126/255.0, alpha: 1.0)
}

struct FontConstants {
    static let bold1 = UIFont.systemFont(ofSize: 16, weight: .bold)
    static let bold2 = UIFont.systemFont(ofSize: 18, weight: .bold)
    static let bold3 = UIFont.systemFont(ofSize: 20, weight: .bold)
    
    static let normal1 = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let normal2 = UIFont.systemFont(ofSize: 18, weight: .medium)
    static let normal3 = UIFont.systemFont(ofSize: 20, weight: .medium)
    
//    static let time = UIFont(name: "PTSans-Bold", size: 12)
    static let small = UIFont.systemFont(ofSize: 12, weight: .light)
}

struct ImageConstants {
    static let mail = UIImage(systemName: "envelope.fill")
    static let person = UIImage(systemName: "person.fill")
    static let appIcon = UIImage(systemName: "message.circle.fill")
    static let password = UIImage(systemName: "lock.square.fill")
    static let menu = UIImage(systemName: "line.3.horizontal")
    static let add = UIImage(systemName: "plus")
    static let search = UIImage(systemName: "magnifyingglass")
    static let back = UIImage(systemName: "chevron.backward")
    static let send = UIImage(systemName: "arrowtriangle.right.fill")
    static let round = UIImage(systemName: "circle")
    static let roundFill = UIImage(systemName: "circle.fill")
    static let unseen = UIImage(systemName: "checkmark.circle")
    static let seen = UIImage(systemName: "checkmark.circle.fill")
    static let picture = UIImage(systemName: "photo.fill")
    static let groupPhoto = UIImage(systemName: "person.3.fill")
    static let info = UIImage(systemName: "info.circle.fill")
}

struct MessageConstants {
    static let emailInvalid = "Email is Invalid. Please Enter a Valid Email ID"
    static let passwordInvalid = "Password is Invalid. Password must contain atleast 8 character with 1 number and 1 special character"
    static let usernameInvalid = "User Name must be atleast 3 Characters"
    static let profilePictureInvalid = "Please Upload a Profile Picture"
    static let groupPhotoInvalid = "Please Upload a Group Picture"
    static let groupNameInvalid = "Please Enter a Valid Group Name"
    static let minimumGroupMemberError = "Please Select Atleast 1 User"
}

struct menuItemConstants {
    static let settings = "Settings"
    static let profile = "Profile"
    static let logout = "Logout"
    static let menuItemArray = [settings, profile, logout]
}

