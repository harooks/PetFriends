//
//  UserInputCell.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/28/21.
//

import UIKit

protocol InputTextFieldCellDelegate {
    func textFieldDidEndEditing(cell: UserInputCell, value: String) -> ()
}

class UserInputCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    var textArray = [String]()
    
    static let identifier = "FieldCell"
    
    var rowBeingEdited : Int? = nil
    
    static func nib() -> UINib {
        return UINib(nibName: "UserInputCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        textArray.append(textField.text!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    var delegate: InputTextFieldCellDelegate! = nil
     
    func textFieldDidEndEditing(_ textField: UITextField) {

        
        print("textFieldDidEndEditing")
        self.delegate.textFieldDidEndEditing(cell: self, value: textField.text!)

        
    }
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        rowBeingEdited = textField.tag
    }
    
}
