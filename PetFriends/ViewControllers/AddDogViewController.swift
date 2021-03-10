//
//  AddDogViewController.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/28/21.
//

import UIKit

class AddDogViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    
    
    @IBOutlet weak var upperView: UIView!
    
    var newName = String()
    var newBreed = String()
    var newOther = String()
    var newGender = Bool()
    var newFav = Bool()
    
    var textFieldArray = [String]()
    
    var design = Design()
    
    
    override func viewDidLoad() {
        
        navigationController?.navigationBar.barTintColor = design.themeColor
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = design.subColor
        
        dogImageView.layer.cornerRadius = 20
        dogImageView.clipsToBounds = true
        table.register(UserInputCell.nib(), forCellReuseIdentifier: UserInputCell.identifier)
        table.register(TextViewTableViewCell.nib(), forCellReuseIdentifier: TextViewTableViewCell.identifier)
        table.register(PickerTableViewCell.nib(), forCellReuseIdentifier: PickerTableViewCell.identifier)
        table.register(FavouriteTableViewCell.nib(), forCellReuseIdentifier: FavouriteTableViewCell.identifier)
        table.register(ButtonCell.nib(), forCellReuseIdentifier: ButtonCell.identifier)
        table.delegate = self
        table.dataSource = self
        
        keyboaredSetting()
    }
    
    //UpperView を動かしたい
//    @objc func panGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
//        //移動量を取得する
//        let move = gestureRecognizer.translation(in: self.view)
//
//        //y軸の移動量をviewの高さに加える
//        self.upperView.frame.size.height += move.y
//
//        //移動量をリセットする
//        gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
//    }
    
    deinit {
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
       }
    
    @IBAction func openCamera(_ sender: Any) {
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
    
    @IBAction func openAlbum(_ sender: Any) {
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
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

}

//===========================================================

extension AddDogViewController {
    //keyboard setting
    
 
    func keyboaredSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil);
    }

    @objc func keyboardWillChange(notification: Notification) {

        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }

        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }

}


extension AddDogViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            dogImageView.image = info[.editedImage] as? UIImage
            dogImageView.isHidden = false
            dismiss(animated: true, completion: nil)

        }
}

extension AddDogViewController: UITableViewDelegate, UITableViewDataSource, InputTextFieldCellDelegate, InputTextViewCellDelegate, InputPickerDelegate, FavouriteCellDelegate {
    
    func didChangeSwitchState(cell: FavouriteTableViewCell, isOn: Bool) {
        newFav = isOn
        print("didChangeSwitchState:  \(newFav)")
    }
    
    
    func pickerView(_ pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = row
        print("selected value from picker is: \(selectedValue)")
        if selectedValue == 0 {
            newGender = false //オス
        } else {
            newGender = true //メス
        }
        print("selected value of newGender is: \(newGender)");
    }
    
    
    func getGenderBool(cell: PickerTableViewCell, value: Bool) {
        newGender = value
        print("gender bool is \(newGender)")
    }
    
    func textViewDidEndEditing(cell: TextViewTableViewCell, value: String) {
   //     let row = 3
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
    } else if indexPath.row == 5 {
        return 50
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
            fieldCell.textField.attributedPlaceholder = NSAttributedString(string: "名前",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            fieldCell.delegate = self
 //           newName = textFieldArray[indexPath.row]

        } else {
            fieldCell.textField.tag = indexPath.row
            print("taags is:\(fieldCell.textField.tag)")
            fieldCell.textField.attributedPlaceholder = NSAttributedString(string: "犬種",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            fieldCell.delegate = self
        }
        return fieldCell
    } else if indexPath.row == 2 {
        let pickerCell = tableView.dequeueReusableCell(withIdentifier: PickerTableViewCell.identifier) as! PickerTableViewCell
        pickerCell.delegate = self
        return pickerCell
    } else if indexPath.row == 3 {
        let textViewCell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier) as! TextViewTableViewCell
        textViewCell.textView.tag = indexPath.row
        textViewCell.delegate = self
        return textViewCell
    } else if indexPath.row == 4 {
        let switchCell = tableView.dequeueReusableCell(withIdentifier: FavouriteTableViewCell.identifier) as! FavouriteTableViewCell
        switchCell.delegate = self
        
//        newFav = switchCell.favouriteSwitch.isOn
//        print("switch value is in cell \(switchCell.isFavourite)")
        return switchCell
    } else {
        let btnCell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.identifier) as! ButtonCell
        return btnCell
    }
}
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
 
        if indexPath.row == 5 {
            
            if self.newName == "" {
                let nameWarningAlert:UIAlertController = UIAlertController(title: "保存できません", message: "名前を記入してください", preferredStyle: .alert)
                nameWarningAlert.addAction(UIAlertAction(
                    title: "OK",
                    style: .cancel
                ))
                
                present(nameWarningAlert, animated: true, completion: nil)
            }
            
            if dogImageView.image == UIImage(named: "defaultDog") {
                let imageWarningAlert:UIAlertController = UIAlertController(title: "写真がありません", message: "写真がないとデフォルトの写真で保存されます", preferredStyle: .alert)
                imageWarningAlert.addAction(UIAlertAction(
                    title: "保存する",
                    style: .default,
                    handler: { action in
                        let dogFirebase = DogFirebase()
                        let newDog = AddedDogStruct(name: self.newName, breed: self.newBreed, gender: self.newGender, fav: self.newFav, bio: self.newOther)
                        dogFirebase.uploadImage(addedDog: newDog, view: self.dogImageView)
                    
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // ここ時間じゃなくす
            //                print("id is \(dogFirebase.id)") //works
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                
                ))
                
                imageWarningAlert.addAction(UIAlertAction (
                    title: "キャンセル",
                    style: .cancel
                ))
                
                present(imageWarningAlert, animated: true, completion: nil)
            }
            
        let alert:UIAlertController = UIAlertController(title: "ともだちを追加", message: "ともだちの情報を保存します", preferredStyle: .alert)
            
        alert.addAction(UIAlertAction (
            
            title: "OK",
            style: .default,
            handler: { action in
                let dogFirebase = DogFirebase()
                let newDog = AddedDogStruct(name: self.newName, breed: self.newBreed, gender: self.newGender, fav: self.newFav, bio: self.newOther)
                dogFirebase.uploadImage(addedDog: newDog, view: self.dogImageView)
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // ここ時間じゃなくす
    //                print("id is \(dogFirebase.id)") //works
                    self.dismiss(animated: true, completion: nil)
                }
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
