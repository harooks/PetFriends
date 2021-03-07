//
//  FavouriteTableViewCell.swift
//  PetFriends
//
//  Created by Haruko Okada on 3/6/21.
//

import UIKit

protocol FavouriteCellDelegate{
    func didChangeSwitchState(cell: FavouriteTableViewCell, isOn: Bool)
}


class FavouriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favouriteSwitch: UISwitch!
    
    static let identifier = "SwitchCell"
    
//    var isFavourite: Bool = false
    
    var switchValueChangedCompletion: (() -> Bool)?
    
    
    static func nib() -> UINib {
        return UINib(nibName: "FavouriteTableViewCell", bundle: nil)
    }
    
    var delegate: FavouriteCellDelegate! = nil
    
    
    @IBAction func switchChanged(_ sender: Any) {
        
        print("switch!!!!!!!!!!\(favouriteSwitch.isOn)")
        if (sender as AnyObject).isOn {
            print("on")
        } else {
            print("off")
        }
        
        self.delegate?.didChangeSwitchState(cell: self, isOn: favouriteSwitch.isOn)
        
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
