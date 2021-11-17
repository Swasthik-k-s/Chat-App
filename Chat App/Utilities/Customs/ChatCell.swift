//
//  ChatCell.swift
//  Chat App
//
//  Created by Swasthik K S on 15/11/21.
//

import UIKit

class ChatCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var nameLabel = CustomLabel(text: "", color: .black, font: FontConstants.bold3)
    var messageLabel = CustomLabel(text: "", color: ColorConstants.grey, font: FontConstants.normal1)
    var dateLabel = CustomLabel(text: "", color: ColorConstants.grey, font: FontConstants.small)
                                
    var profileImage = CustomImageView(image: UIImage(systemName: "person.fill")!, height: 50, width: 50, cornerRadius: 25, color: ColorConstants.customWhite)
    
    func configureCell() {
        
        profileImage.backgroundColor = ColorConstants.grey
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        let infoStack = UIStackView(arrangedSubviews: [nameLabel, messageLabel])
        infoStack.spacing = 10
        infoStack.axis = .vertical
        infoStack.alignment = .leading
//        infoStack.alignment = .center
        
        addSubview(profileImage)
        addSubview(infoStack)
        addSubview(dateLabel)
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            profileImage.widthAnchor.constraint(equalToConstant: 50),
//            profileImage.heightAnchor.constraint(equalToConstant: 50),
            
            infoStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            infoStack.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 10),
            infoStack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -60),
            
            dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
//            dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        
        ])
    }
}
