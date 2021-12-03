//
//  Extension + Cell.swift
//  Chat App
//
//  Created by Swasthik K S on 03/12/21.
//

import UIKit

extension UITableViewCell {
    func dateToStringConvertor(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        
        return dateFormatter.string(from: date)
    }
}
