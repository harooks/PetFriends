//
//  PickerTableViewCell.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/28/21.
//

import UIKit

protocol InputPickerDelegate {

    func getGenderBool(cell: PickerTableViewCell, value: Bool)
}

class PickerTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var genderPicker: UIPickerView!
    
    static let identifier = "pickerCell"
    
    static func nib() -> UINib {
    return UINib(nibName: "PickerTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        genderPicker.delegate = self
        genderPicker.dataSource = self
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        2
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let genderChoiceArray = ["オス", "メス"]
        return genderChoiceArray[row]
    }
    
    var delegate: InputPickerDelegate! = nil
    var genderBool = Bool()
    
    
    func getGenderBool(_ pickerView: UIPickerView) {
        
        self.delegate.getGenderBool(cell: self, value: genderBool)
        
        
        let selectedValue = genderPicker.selectedRow(inComponent: 0)
        if selectedValue == 0 {
            genderBool = true
        } else {
            genderBool = false
        }
 //       return genderBool

    }
    
    
}
