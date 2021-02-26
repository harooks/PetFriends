//
//  DogTableViewCell.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/24/21.
//

import UIKit

class DogTableViewCell: UITableViewCell {
    
    
    
    
    let dogImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameTextLabel: UILabel = {
        let label = UILabel()
        label.text = "名前"
        label.font = .systemFont(ofSize: 18)
        label.sizeToFit()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(dogImageView)
        addSubview(nameTextLabel)
        [
            dogImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            dogImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            dogImageView.widthAnchor.constraint(equalToConstant: 50),
            dogImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameTextLabel.heightAnchor.constraint(equalToConstant: 20),
            nameTextLabel.leadingAnchor.constraint(equalTo: dogImageView.trailingAnchor, constant: 20),
//            nameTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameTextLabel.rightAnchor.constraint(equalTo: rightAnchor),
            
            ].forEach{ $0.isActive = true }
        
        dogImageView.layer.cornerRadius = 25
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
