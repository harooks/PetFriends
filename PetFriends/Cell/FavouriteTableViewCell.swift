//
//  FavouriteTableViewCell.swift
//  PetFriends
//
//  Created by Haruko Okada on 3/6/21.
//

import UIKit

//protocol FavouriteCellDelegate{
//    func switchChanged(_ sender: UISwitch)
//}


class FavouriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favouriteSwitch: UISwitch!
    
    static let identifier = "SwitchCell"
    
    var isFavourite: Bool = false
    
    static func nib() -> UINib {
        return UINib(nibName: "FavouriteTableViewCell", bundle: nil)
    }
    
//    var delegate: FavouriteCellDelegate! = nil
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if favouriteSwitch.isOn {
            isFavourite = true
        } else {
            isFavourite = false
        }
  //      self.delegate.switchChanged(favouriteSwitch)
//        self.delegate.switchChanged(favouriteSwitch)
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
