//
//  AddFriendViewController.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/24/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth


class AddDogViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    let dogFirebase = DogFirebase()
    
    let design = Design()
    
    let outView = UIView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let dogImageView = UIImageView()
    
    let cameraButton = UIButton(type: .custom)
    let photoLibraryButton = UIButton(type: .custom)
    let saveButton = UIButton(type: .custom)
    
    let nameLabel = UILabel()
    let breedLabel = UILabel()
    let genderLabel = UILabel()
    let othersLabel = UILabel()
    var labelArray = [UILabel]()
    
    let nameTextField = UITextField()
    let breedTextField = UITextField()
    
    let genderPicker = UIPickerView()
    
    let othersTextView = UITextView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogImageView.image = UIImage(named: "defaultDog")
        dogImageView.isHidden = true

        keyboaredSetting()
        setupScrollView()
        setImageView()
        setPhotoButtons()
        setLabels()
        setTextFields()
        setPickerView()
        setTextView()
        
        print("view did loadi")
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
     }
    
    
    func setupScrollView(){
        outView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(outView)
        outView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.backgroundColor = design.themeColor

   [
        outView.leftAnchor.constraint(equalTo: view.leftAnchor),
        outView.rightAnchor.constraint(equalTo: view.rightAnchor),
        outView.topAnchor.constraint(equalTo: view.topAnchor),
        outView.bottomAnchor.constraint(equalTo: view.bottomAnchor),


        scrollView.leftAnchor.constraint(equalTo: outView.leftAnchor),
        scrollView.rightAnchor.constraint(equalTo: outView.rightAnchor),
        scrollView.topAnchor.constraint(equalTo: outView.topAnchor),
        scrollView.bottomAnchor.constraint(equalTo: outView.bottomAnchor),


        contentView.widthAnchor.constraint(equalTo: outView.widthAnchor),
        contentView.heightAnchor.constraint(equalToConstant: 1000.0),
        contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
        contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
   ].forEach{ $0.isActive = true }

    }
    
    func setImageView() {
        
        dogImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dogImageView)
        design.cornerRadius(dogImageView)
        
        [
            dogImageView.heightAnchor.constraint(equalTo: dogImageView.widthAnchor),
            dogImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            dogImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dogImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60),
            dogImageView.trailingAnchor.constraint(equalTo: dogImageView.leadingAnchor),
  
        ].forEach{ $0.isActive = true }
    }
    
    func setPhotoButtons() {
        
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        photoLibraryButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cameraButton)
        contentView.addSubview(photoLibraryButton)
        contentView.addSubview(saveButton)
        
        
        //button methods
        cameraButton.addTarget(self, action: #selector(takePhotoButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        photoLibraryButton.addTarget(self, action: #selector(openAlbumButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        saveButton.addTarget(self, action: #selector(saveData(_:)), for: UIControl.Event.touchUpInside)

        
        //button design
        cameraButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        photoLibraryButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        saveButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
//        design.dropShadow1(view: cameraButton)
        design.cornerRadius(cameraButton)
        design.cornerRadius(photoLibraryButton)
        design.cornerRadius(saveButton)
        
        //button title
        cameraButton.setTitle("写真を撮る", for: UIControl.State.normal)
        photoLibraryButton.setTitle("アルバム", for: UIControl.State.normal)
        saveButton.setTitle("保存", for: UIControl.State.normal)
        
        [
            cameraButton.leadingAnchor.constraint(equalTo: dogImageView.leadingAnchor),
            photoLibraryButton.trailingAnchor.constraint(equalTo: dogImageView.trailingAnchor),
            cameraButton.topAnchor.constraint(equalTo: dogImageView.bottomAnchor, constant: 20),
            photoLibraryButton.topAnchor.constraint(equalTo: dogImageView.bottomAnchor, constant: 20),
            photoLibraryButton.widthAnchor.constraint(equalTo: cameraButton.widthAnchor),
            cameraButton.trailingAnchor.constraint(equalTo: photoLibraryButton.leadingAnchor, constant: -20),
            photoLibraryButton.heightAnchor.constraint(equalTo: dogImageView.heightAnchor, multiplier: 0.20),
            cameraButton.heightAnchor.constraint(equalTo: dogImageView.heightAnchor, multiplier: 0.20),
            
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),
//            saveButton.topAnchor.constraint(equalTo: othersTextView.bottomAnchor),
            saveButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: cameraButton.widthAnchor),
            saveButton.heightAnchor.constraint(equalTo: cameraButton.heightAnchor),

        ].forEach{ $0.isActive = true }
    }
 
    
    func setLabels() {
        labelArray = [nameLabel, breedLabel, genderLabel, othersLabel]
        nameLabel.text = "名前"
        breedLabel.text = "犬種"
        genderLabel.text = "性別"
        othersLabel.text = "その他"
        
        for label in labelArray {
            label.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(label)
            design.cornerRadius(label)
            label.textColor = UIColor.white
            label.font = UIFont(name: "Rubik", size: 22)
            label.leadingAnchor.constraint(equalTo: dogImageView.leadingAnchor).isActive = true
            label.widthAnchor.constraint(equalTo: cameraButton.widthAnchor, multiplier: 0.6).isActive = true
            label.heightAnchor.constraint(equalTo: label.widthAnchor, multiplier: 0.5).isActive = true
            
        }
        
        [
            nameLabel.topAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: 40),
            breedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            genderLabel.topAnchor.constraint(equalTo: breedLabel.bottomAnchor, constant: 20),
            othersLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 20),
        ].forEach{ $0.isActive = true }

        
    }
    
    func setTextFields() {
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        breedTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.backgroundColor = UIColor.white
        breedTextField.backgroundColor = UIColor.white
        contentView.addSubview(nameTextField)
        contentView.addSubview(breedTextField)
        
        nameTextField.delegate = self
        breedTextField.delegate = self
        
        //design
        design.cornerRadius(nameTextField)
        design.cornerRadius(breedTextField)
        
        
        [
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: dogImageView.trailingAnchor),
            nameTextField.topAnchor.constraint(equalTo: photoLibraryButton.bottomAnchor, constant: 40),
            nameTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            
    
            breedTextField.leadingAnchor.constraint(equalTo: breedLabel.trailingAnchor, constant: 20),
            breedTextField.trailingAnchor.constraint(equalTo: dogImageView.trailingAnchor),
            breedTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            breedTextField.heightAnchor.constraint(equalTo: breedLabel.heightAnchor),

        ].forEach{ $0.isActive = true }
    
    }
    
    func setPickerView() {
        genderPicker.translatesAutoresizingMaskIntoConstraints = false
 //       genderPicker.backgroundColor = UIColor.white
        
        contentView.addSubview(genderPicker)
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
        
        [
            genderPicker.trailingAnchor.constraint(equalTo: dogImageView.trailingAnchor),
            genderPicker.leadingAnchor.constraint(equalTo: genderLabel.trailingAnchor, constant: 20),
            genderPicker.topAnchor.constraint(equalTo: breedTextField.bottomAnchor, constant: 15),
            genderPicker.heightAnchor.constraint(equalTo: breedLabel.heightAnchor),
        
        ].forEach{ $0.isActive = true }
    }
    
    func setTextView() {
        othersTextView.translatesAutoresizingMaskIntoConstraints = false
        othersTextView.backgroundColor = UIColor.white
        othersTextView.isScrollEnabled = false
        contentView.addSubview(othersTextView)
        othersTextView.delegate = self
        
        //design
        design.cornerRadius(othersTextView)
  
        [
            othersTextView.trailingAnchor.constraint(equalTo: dogImageView.trailingAnchor),
            othersTextView.leadingAnchor.constraint(equalTo: othersLabel.trailingAnchor, constant: 20),
            othersTextView.topAnchor.constraint(equalTo: genderPicker.bottomAnchor, constant: 25),
            othersTextView.heightAnchor.constraint(equalTo: dogImageView.heightAnchor, multiplier: 0.5),
            
        ].forEach{ $0.isActive = true }
    }
    
    
    //---------------------------------------------//
    

       @objc func takePhotoButtonTapped(_ sender: UIButton) {
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
           
           print("hello")
           
       }
       
       @objc func openAlbumButtonTapped(_ sender: UIButton) {
           if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
               //カメラを起動
               let picker = UIImagePickerController()
               picker.sourceType = .photoLibrary
               picker.delegate = self
               picker.allowsEditing = true
   //
               present(picker, animated: true, completion: nil)
           } else {
               print("error using camera")
           }
       }
    
 
   
    @objc func saveData(_ sender: UIButton) {
        guard let name = nameTextField.text, let otherInfo = othersTextView.text, let breed = breedTextField.text else { return }

        let gender = getGenderBool()

        let newDog = AddedDogStruct(name: name, breed: breed, gender: gender, bio: otherInfo)
        
        var dogModel = DogFirebase()
        
       
        
        dogFirebase.uploadImage(addedDog: newDog, view: dogImageView)
        
        dismiss(animated: true, completion: nil)
}


    
    func getGenderBool() -> Bool {
        let selectedValue = genderPicker.selectedRow(inComponent: 0)
        if selectedValue == 0 {
            return true
        } else {
            return false
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



extension AddDogViewController: UIPickerViewDelegate, UIPickerViewDataSource{

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
}
//

//
//}
//
//
//
extension AddDogViewController {
    //keyboard setting
    
    func hideKeyboard() {
        nameTextField.resignFirstResponder()
        breedTextField.resignFirstResponder()
        othersTextView.resignFirstResponder()
     }

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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        hideKeyboard()
        print("is this working")
        return true
    }

}
