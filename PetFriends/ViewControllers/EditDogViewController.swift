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
        
//        navigationController?.navigationBar.barTintColor = design.themeColor
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.tintColor = design.subColor
        
        
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
        keyboaredSetting()
        setSwipeBack()
    }
    
    deinit {
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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

extension EditDogViewController {
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
            fieldCell.textField.placeholder = "名前"

            fieldCell.delegate = self
 //           newName = textFieldArray[indexPath.row]

        } else {
            fieldCell.textField.tag = indexPath.row
            print("taags is:\(fieldCell.textField.tag)")
            fieldCell.textField.text = newBreed
            fieldCell.textField.placeholder = "犬種"
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
            
            
            let newDog = AddedDogStruct(name: newName, breed: newBreed, gender: newGender, fav: newFav, bio: newOther)
//            
            let dogFirebase = DogFirebase()
            dogFirebase.updateData(id: documentId, name: newName, breed: newBreed, bio: newOther, gender: newGender, fav: newFav, imageUrl: newImageUrl)
 //           dogFirebase.uploadImage(addedDog: newDog, view: dogImageView)
            dogFirebase.updateImage(id: documentId, name: newName, breed: newBreed, bio: newOther, gender: newGender, fav: newFav, view: dogImageView)
//            
            print("name is\(newDog.name)")
            print("breed is \(newBreed)")
            print("switch value is \(newFav)")
//            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.navigationController?.popToRootViewController(animated: true)
            }
//            
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
