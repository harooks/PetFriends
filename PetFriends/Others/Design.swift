//
//  Design.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/27/21.
//

import Foundation
import UIKit

class Design: UIColor {

    let themeColor = UIColor(red: 160/255, green: 207/255, blue: 103/255, alpha: 1.0)
    
    let subColor = UIColor(red: 66/255, green: 105/255, blue: 60/255, alpha: 1.0)
    
    let gray =  UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
    
    
    var cornerRadius:(UIView) -> () = { view in
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
    }
    
    func textFieldDesign(textField: UITextField) {
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = subColor.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
    }
    
    func textViewDesign(textView: UITextView) {
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1.5
        textView.layer.borderColor = subColor.cgColor

    }
    
    func ViewDesign(view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.5
        view.layer.borderColor = subColor.cgColor
    }



}
