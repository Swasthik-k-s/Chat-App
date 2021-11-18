//
//  ChatCell.swift
//  Chat App
//
//  Created by Swasthik K S on 15/11/21.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var select: Bool = false
    
    var normalView = UIView()
    
    var nameLabel = CustomLabel(text: "", color: .black, font: FontConstants.bold3)
    var messageLabel = CustomLabel(text: "", color: ColorConstants.grey, font: FontConstants.normal1)
    var dateLabel = CustomLabel(text: "", color: ColorConstants.grey, font: FontConstants.small)
                                
    var profileImage = CustomImageView(image: UIImage(systemName: "person.fill")!, height: 50, width: 50, cornerRadius: 25, color: ColorConstants.customWhite)
    
    var selectButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageConstants.round, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.tintColor = ColorConstants.tealGreen
       
//        button.backgroundColor = .red
        
        return button
    }()
    
    @objc func handleSelect() {
        print("Selected")
        select = !select
        if select {
            selectButton.setImage(ImageConstants.roundFill, for: .normal)
        } else {
            selectButton.setImage(ImageConstants.round, for: .normal)
        }
    }
    
    func animateView(open: Bool) {
        if open {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.frame.origin.x = 62
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.frame.origin.x = 0
            },completion: nil)
        }
    }
    
    func configureCell() {
        
        selectButton.addTarget(self, action: #selector(handleSelect), for: .touchUpInside)
        
        profileImage.backgroundColor = ColorConstants.grey
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        let infoStack = UIStackView(arrangedSubviews: [nameLabel, messageLabel])
        infoStack.spacing = 10
        infoStack.axis = .vertical
        infoStack.alignment = .leading

        addSubview(normalView)
        addSubview(selectButton)
        
        normalView.addSubview(profileImage)
        normalView.addSubview(infoStack)
        normalView.addSubview(dateLabel)

//        insertSubview(selectButton, at: 0)
        
        
        normalView.translatesAutoresizingMaskIntoConstraints = false
//        editView.translatesAutoresizingMaskIntoConstraints = false
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            normalView.leftAnchor.constraint(equalTo: self.leftAnchor),
            normalView.rightAnchor.constraint(equalTo: self.rightAnchor),
            normalView.topAnchor.constraint(equalTo: self.topAnchor),
            normalView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            selectButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: -50),
            selectButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            profileImage.leftAnchor.constraint(equalTo: normalView.leftAnchor, constant: 10),
            profileImage.centerYAnchor.constraint(equalTo: normalView.centerYAnchor),
            
            infoStack.centerYAnchor.constraint(equalTo: normalView.centerYAnchor),
            infoStack.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 10),
            infoStack.rightAnchor.constraint(equalTo: normalView.rightAnchor, constant: -60),
            
            dateLabel.rightAnchor.constraint(equalTo: normalView.rightAnchor, constant: -10),
            dateLabel.centerYAnchor.constraint(equalTo: normalView.centerYAnchor),
            
        
        ])
    }
    
    
}
