//
//  ButtonCell.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/28/21.
//

import UIKit

class ButtonCell: UITableViewCell {
    
    
    static let identifier = "btnCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ButtonCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
