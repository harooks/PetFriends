//
//  TextViewTableViewCell.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/28/21.
//

import UIKit

protocol InputTextViewCellDelegate {
    func textViewDidEndEditing(cell: TextViewTableViewCell, value: String) -> ()
}

class TextViewTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    var textChanged: ((String) -> Void)?
    
    static let identifier = "textCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "TextViewTableViewCell", bundle: nil)
    }
    
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textChanged?(textView.text)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
       textView.resignFirstResponder()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    var delegate: InputTextViewCellDelegate! = nil
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
        self.delegate.textViewDidEndEditing(cell: self, value: textView.text)
        
    }
    
}
