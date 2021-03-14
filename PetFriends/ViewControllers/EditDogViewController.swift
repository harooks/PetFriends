//
//  EditDogViewController.swift
//  PetFriends
//
//  Created by Haruko Okada on 3/3/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class EditDogViewController: UIViewController {
    
    @IBOutlet weak var dogImageView: UIImageView!
    
    @IBOutlet weak var table: UITableView!
    
    var newName = String()
    var newBreed = String()
    var newOther = String()
    var newGender = Bool()
    var newFav = Bool()
    var newImageUrl = String()
    var documentId = String()
    var textFieldArray = [String]()
    

    var design = Design()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dogImageView.layer.cornerRadius = 20
        dogImageView.clipsToBounds = true
        
        print("imageURL is in DetailVC is :\(newImageUrl)")
        
        let url = URL(string: self.newImageUrl)
    do {
        let data = try Data(contentsOf: url!)
        let image = UIImage(data: data)
        self.dogImageView.image = image
        print("success")
    }  catch let err {
        print("Error : \(err.localizedDescription)")
    }

        table.register(UserInputCell.nib(), forCellReuseIdentifier: UserInputCell.identifier)
       
        table.register(TextViewTableViewCell.nib(), forCellReuseIdentifier: TextViewTableViewCell.identifier)
       
        table.register(PickerTableViewCell.nib(), forCellReuseIdentifier: PickerTableViewCell.identifier)
       
        table.register(FavouriteTableViewCell.nib(), forCellReuseIdentifier: FavouriteTableViewCell.identifier)
       
        table.register(ButtonCell.nib(), forCellReuseIdentifier: ButtonCell.identifier)
        table.delegate = self
        table.dataSource = self

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        setSwipeBack()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
      
      // move the root view up by the distance of keyboard height
      self.view.frame.origin.y = 0 - keyboardSize.height
    }
    

    func setSwipeBack() {
        let target = self.navigationController?.value(forKey: "_cachedInteractionController")
        let recognizer = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        self.view.addGestureRecognizer(recognizer)
    }
    
    
    @IBAction func openCameraTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //カメラを起動
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true

            present(picker, animated: true, completion: nil)
        } else {
            print("error using camera")
        }
        
    }
    
    
    @IBAction func openAlbumTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
             //カメラを起動
             let picker = UIImagePickerController()
             picker.sourceType = .photoLibrary
             picker.delegate = self
             picker.allowsEditing = true
             present(picker, animated: true, completion: nil)
         } else {
             print("error using camera")
         }
    }
    
    @objc func changeSwitch(_ sender: UISwitch) {
        
        newFav = sender.isOn
        print("sender the switch ran : \(newFav)")
    }
    
    @IBAction func returnToHomeTapped(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)
    
    }
    

}


extension EditDogViewController: UITableViewDelegate, UITableViewDataSource, InputTextFieldCellDelegate, InputTextViewCellDelegate, InputPickerDelegate, FavouriteCellDelegate {
    
    func didChangeSwitchState(cell: FavouriteTableViewCell, isOn: Bool) {
        newFav = isOn
        print("didChangeSwitchState!:  \(newFav)")
    }
    
    
    func pickerView(_ pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = row
        print("selected value from picker is: \(selectedValue)");
        newGender = (selectedValue != 0)
    }
    
    
    func textViewDidEndEditing(cell: TextViewTableViewCell, value: String) {
        newOther = value
    }
    
    
    func textFieldDidEndEditing(cell: UserInputCell, value: String) {
        let row = cell.textField.tag
        
        if row == 0 {
            newName = value
        } else if row == 1 {
            newBreed = value
        }

        print("new name value: \(newName)")
        print("new breed value: \(newBreed)")
    }
    


func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if indexPath.row < 2 {
        return 40
    } else if indexPath.row == 2 {
        return 80
    } else if indexPath.row == 3 {
        return 120
    } else {
        return 40
    }
    
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    6
}

    

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if indexPath.row < 2 {
        let fieldCell = tableView.dequeueReusableCell(withIdentifier: UserInputCell.identifier) as! UserInputCell
        if indexPath.row == 0 {
            fieldCell.textField.tag = indexPath.row
            fieldCell.textField.text = newName
            fieldCell.textField.attributedPlaceholder = NSAttributedString(string: "名前",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])

            fieldCell.delegate = self
 //           newName = textFieldArray[indexPath.row]

        } else {
            fieldCell.textField.tag = indexPath.row
            print("taags is:\(fieldCell.textField.tag)")
            fieldCell.textField.text = newBreed
            fieldCell.textField.attributedPlaceholder = NSAttributedString(string: "犬種",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            fieldCell.delegate = self
 
        }
        return fieldCell
    } else if indexPath.row == 2 {
        let pickerCell = tableView.dequeueReusableCell(withIdentifier: PickerTableViewCell.identifier) as! PickerTableViewCell
 //       pickerCell.genderPicker.
        pickerCell.delegate = self
        var selectedRow:Int = 0
        if newGender == true {
            selectedRow = 1
        } else {
            selectedRow = 0
        }
        pickerCell.genderPicker.selectRow(selectedRow, inComponent: 0, animated: false)
        
        return pickerCell
    } else if indexPath.row == 3 {
        let textViewCell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier) as! TextViewTableViewCell
        textViewCell.textView.tag = indexPath.row
        textViewCell.textView.text = newOther
        textViewCell.delegate = self
        return textViewCell
    } else if indexPath.row == 4 {
        let switchCell = tableView.dequeueReusableCell(withIdentifier: FavouriteTableViewCell.identifier) as! FavouriteTableViewCell
//        switchCell.favouriteSwitch.isOn = newFav
        print("edit view newFav is :\(newFav)")
        if newFav == true {
            switchCell.favouriteSwitch.isOn = true
        } else {
            switchCell.favouriteSwitch.isOn = false
        }
        switchCell.delegate = self
        return switchCell
    } else {
        let btnCell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.identifier) as! ButtonCell
        return btnCell
    }
}
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
        if indexPath.row == 5 {
            
            if self.newName == "" {
                let nameWarningAlert:UIAlertController = UIAlertController(title: "保存できません", message: "名前を記入してください", preferredStyle: .alert)
                nameWarningAlert.addAction(UIAlertAction(
                    title: "OK",
                    style: .cancel
                ))
                
                present(nameWarningAlert, animated: true, completion: nil)
            }
            
            let alert:UIAlertController = UIAlertController(title: "ともだちを追加", message: "ともだちの情報を保存します", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction (
                
                title: "OK",
                style: .default,
                handler: { action in
//                    let newDog = AddedDogStruct(name: self.newName, breed: self.newBreed, gender: self.newGender, fav: self.newFav, bio: self.newOther)
        //
                    let dogFirebase = DogFirebase()
                    dogFirebase.updateData(id: self.documentId, name: self.newName, breed: self.newBreed, bio: self.newOther, gender: self.newGender, fav: self.newFav, imageUrl: self.newImageUrl)
                    
                    dogFirebase.updateImage(id: self.documentId, name: self.newName, breed: self.newBreed, bio: self.newOther, gender: self.newGender, fav: self.newFav, view: self.dogImageView, vc: self)

                }
            ))
            
            alert.addAction(UIAlertAction (
                title: "キャンセル",
                style: .cancel
            ))
            
            present(alert, animated: true, completion: nil)

            
        } else {return}
    
    }

}


extension EditDogViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dogImageView.image = info[.editedImage] as? UIImage
        dogImageView.isHidden = false
        dismiss(animated: true, completion: nil)

    }

}
