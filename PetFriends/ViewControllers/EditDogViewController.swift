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
    var newImageUrl = String()
    var documentId = String()
    var textFieldArray = [String]()
     
    override func viewDidLoad() {
        super.viewDidLoad()
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
        table.register(ButtonCell.nib(), forCellReuseIdentifier: ButtonCell.identifier)
        table.delegate = self
        table.dataSource = self
        
        setSwipeBack()
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
    
    
    

}

extension EditDogViewController: UITableViewDelegate, UITableViewDataSource, InputTextFieldCellDelegate, InputTextViewCellDelegate, InputPickerDelegate {
    
    
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
        return 50
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
        return pickerCell
    } else if indexPath.row == 3 {
        let textViewCell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier) as! TextViewTableViewCell
        textViewCell.textView.tag = indexPath.row
        textViewCell.textView.text = newOther
        textViewCell.delegate = self
        return textViewCell
    } else {
        let btnCell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.identifier) as! ButtonCell
        return btnCell
    }
}
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
        if indexPath.row == 4 {
            let newDog = AddedDogStruct(name: newName, breed: newBreed, gender: newGender, bio: newOther)
//            
            let dogFirebase = DogFirebase()
                dogFirebase.updateData(id: documentId, name: newName, breed: newBreed, bio: newOther, gender: newGender, imageUrl: newImageUrl)
 //           dogFirebase.uploadImage(addedDog: newDog, view: dogImageView)
            dogFirebase.updateImage(id: documentId, name: newName, breed: newBreed, bio: newOther, gender: newGender, view: dogImageView)
//            
            print("name is\(newDog.name)")
            print("breed is \(newBreed)")
            print("save button worked ")
//            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
