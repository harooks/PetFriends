//
//  PickerTableViewCell.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/28/21.
//

import UIKit

protocol InputPickerDelegate {
    func pickerView(_ pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
//    func getGenderBool(cell: PickerTableViewCell, value: Bool)
}

class PickerTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var genderPicker: UIPickerView!
    var genderChoiceArray = [String]()

    
    static let identifier = "pickerCell"
    
    static func nib() -> UINib {
    return UINib(nibName: "PickerTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        genderPicker.setValue(UIColor.black, forKey: "textColor")
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
        
 //       self.delegate.pickerView(pickerView, titleForRow: row, forComponent: 0)
        genderChoiceArray = ["オス", "メス"]
        let myTitle = NSAttributedString(string: genderChoiceArray[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return genderChoiceArray[row]
    }
    
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        return NSAttributedString(string: genderChoiceArray[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
//    }

    
    var delegate: InputPickerDelegate! = nil
//    var genderBool = Bool()
    
    
//    func getGenderBool(_ pickerView: UIPickerView) {
//
////self.delegate.getGenderBool(cell: self, value: genderBool)
//
//
//        let selectedValue = genderPicker.selectedRow(inComponent: 0)
//        if selectedValue == 0 {
//            genderBool = true
//        } else {
//            genderBool = false
//        }
//
//        print("selectedValue of gender is: \(selectedValue)")
// //       return genderBool
//
//    }
    
    func pickerView(_ pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        self.delegate.pickerView(pickerView, didSelectRow: row, inComponent: 0)
    }
    
    
}
