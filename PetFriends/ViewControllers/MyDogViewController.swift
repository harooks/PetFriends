//
//  MyDogViewController.swift
//  PetFriends
//
//  Created by Haruko Okada on 3/8/21.
//

import UIKit

class MyDogViewController: UIViewController {
    
    @IBOutlet weak var dogImageView: UIImageView!
    
    @IBOutlet weak var table: UITableView!

    var dogFirebase = DogFirebase()
    var myDogName = String()
    var myDogBreed = String()
    var myDogGender = Bool()
    var myDogBio = String()
    var myDogId = String()
    var myDogImageUrl = String()
    let saveData = UserDefaults.standard
    var myDog = RegisteredDogModel(dic: ["id": String.self])
    
    
    override func viewWillAppear(_ animated: Bool) {
        
            dogFirebase.getRegisteredDogData { (dog) in
            self.myDog = dog
                self.myDogName = dog.name
                self.myDogBreed = dog.breed
                self.myDogBio = dog.bio
                self.myDogGender = dog.gender
                self.myDogId = dog.id
                print("dog.id is \(dog.id)")
                self.myDogImageUrl = dog.imageUrl
                let url = URL(string: self.myDogImageUrl)
            do {
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)
                self.dogImageView.image = image
                print("success")
            }  catch let err {
                print("Error : \(err.localizedDescription)")
            }
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogImageView.layer.cornerRadius = 20
        dogImageView.clipsToBounds = true
print("dog image corner radius is \(dogImageView.layer.cornerRadius)")

        table.register(UserInputCell.nib(), forCellReuseIdentifier: UserInputCell.identifier)
        table.register(TextViewTableViewCell.nib(), forCellReuseIdentifier: TextViewTableViewCell.identifier)
        table.register(PickerTableViewCell.nib(), forCellReuseIdentifier: PickerTableViewCell.identifier)
        table.register(FavouriteTableViewCell.nib(), forCellReuseIdentifier: FavouriteTableViewCell.identifier)
        table.register(ButtonCell.nib(), forCellReuseIdentifier: ButtonCell.identifier)
        table.delegate = self
        table.dataSource = self
        
        keyboaredSetting()
        
        print("my dog bio is \(myDogBio)")
        
    }
    
    

    @IBAction func openCameraTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //カメラを起動
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            print("take photo")
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
            print("open album")
             present(picker, animated: true, completion: nil)
         } else {
             print("error using camera")
         }
    }
    
}

extension MyDogViewController {
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

extension MyDogViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            dogImageView.image = info[.editedImage] as? UIImage
            dogImageView.isHidden = false
            dismiss(animated: true, completion: nil)

        }
}

extension MyDogViewController: UITableViewDelegate, UITableViewDataSource, InputTextFieldCellDelegate, InputTextViewCellDelegate, InputPickerDelegate {
    
    
    
    func pickerView(_ pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = row
        print("selected value from picker is: \(selectedValue)")
        if selectedValue == 0 {
            myDogGender = false //オス
        } else {
            myDogGender = true //メス
        }
        print("selected value of newGender is: \(myDogGender)");
    }
    
    
    func getGenderBool(cell: PickerTableViewCell, value: Bool) {
        myDogGender = value
        print("gender bool is \(myDogGender)")
    }
    
    func textViewDidEndEditing(cell: TextViewTableViewCell, value: String) {
   //     let row = 3
        myDogBio = value
    }
    
    
    func textFieldDidEndEditing(cell: UserInputCell, value: String) {
        let row = cell.textField.tag
        
        if row == 0 {
            myDogName = value
        } else if row == 1 {
            myDogBreed = value
        }
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
    5
}

    

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if indexPath.row < 2 {
        let fieldCell = tableView.dequeueReusableCell(withIdentifier: UserInputCell.identifier) as! UserInputCell
        if indexPath.row == 0 {
            fieldCell.textField.tag = indexPath.row
            fieldCell.textField.text = myDogName
//            fieldCell.textField.text = self.myDogName
            fieldCell.textField.attributedPlaceholder = NSAttributedString(string: "名前",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            fieldCell.delegate = self
 //           newName = textFieldArray[indexPath.row]

        } else {
            fieldCell.textField.tag = indexPath.row
            fieldCell.textField.text = myDogBreed
            
            fieldCell.textField.attributedPlaceholder = NSAttributedString(string: "犬種",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            fieldCell.delegate = self
        }
        print("breed of my dog is \(myDog.breed)")
        return fieldCell
    } else if indexPath.row == 2 {
        let pickerCell = tableView.dequeueReusableCell(withIdentifier: PickerTableViewCell.identifier) as! PickerTableViewCell
        pickerCell.delegate = self
        var selectedRow:Int = 0
        if myDog.gender == true {
            selectedRow = 1
        } else {
            selectedRow = 0
        }
        pickerCell.genderPicker.selectRow(selectedRow, inComponent: 0, animated: false)
        return pickerCell
    } else if indexPath.row == 3 {
        let textViewCell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier) as! TextViewTableViewCell
        textViewCell.textView.tag = indexPath.row
        textViewCell.textView.text = myDogBio
        textViewCell.delegate = self
        return textViewCell
    } else {
        let btnCell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.identifier) as! ButtonCell
        return btnCell
    }
}
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        if indexPath.row == 4 {
            
            if myDog.name == "" {
                let nameWarningAlert:UIAlertController = UIAlertController(title: "保存できません", message: "名前を記入してください", preferredStyle: .alert)
                nameWarningAlert.addAction(UIAlertAction(
                    title: "OK",
                    style: .cancel
                ))
                
                present(nameWarningAlert, animated: true, completion: nil)
            }
    
            
        let alert:UIAlertController = UIAlertController(title: "ペットプロフィールを保存", message: "マイペットの情報を更新します", preferredStyle: .alert)
            
        alert.addAction(UIAlertAction (
            
            title: "OK",
            style: .default,
            handler: { action in
//                let updatedMyDog = MyDogStruct(name: self.myDogName, breed: self.myDogBreed, gender: self.myDogGender, bio: self.myDogBio)
                
                print("id id is \(self.myDogId)")
                print("image url url is \(self.myDogImageUrl)")
                
                self.dogFirebase.updatedMyDogData(id: self.myDogId, name: self.myDogName, breed: self.myDogBreed, bio: self.myDogBio, gender: self.myDogGender, imageUrl: self.myDogImageUrl)

                self.dogFirebase.updateMyDogImage(id: self.myDogId, name: self.myDogName, breed: self.myDogBreed, bio: self.myDogBio, gender: self.myDogGender, view: self.dogImageView)

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

