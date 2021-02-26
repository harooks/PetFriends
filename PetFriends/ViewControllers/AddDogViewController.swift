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


class AddDogViewController: UIViewController {
    
    let userdefualts = UserDefaults.standard
    let choiceArray = ["オス", "メス"]
    
    //outlets
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var dogName: UITextField!
    @IBOutlet weak var dogBreed: UITextField!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var othersTextView: UITextView!
    
    //buttons
    @IBOutlet weak var addDogButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var openAlbumButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        genderPicker.delegate = self
        genderPicker.dataSource = self
        keyboaredSetting()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func takePhotoButtonTapped(_ sender: Any) {
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
    
    @IBAction func openAlbumButtonTapped(_ sender: Any) {
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
    
    @IBAction func addDogButtonTapped(_ sender: Any) {
        saveImageToCloudStorage()
        saveData()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
 
    
 
    
    func saveData() {
        
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser
        let uidString = String(currentUser!.uid)

        let name = dogName.text
        let breed = dogBreed.text
        let gender = getGenderBool()
        let otherInfo = othersTextView.text
//        let uuid = UUID()
//        let newDogId = uuid.uuidString

        db.collection("users").document(uidString).collection("savedDogs").addDocument(data: [
            "name": name ?? "わからない",
            "breed": breed ?? "Unknown",
            "otherInfo": otherInfo ?? "なし",
            "gender": gender
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        print("this metod")
    }
    
    func saveImageToCloudStorage() {
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "dog/\(randomID).jpeg")
        guard let imageData = dogImageView.image?.jpegData(compressionQuality: 0.75) else {
            print("not working")
            return }

        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"

        uploadRef.putData(imageData, metadata: uploadMetadata) {(downloadMetaData, err) in
            if let err = err {
                print("there is an error: \(err)")
            } else {
                print("put is complete \(downloadMetaData)")
            }

        }
        print("i ran")
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




extension AddDogViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return choiceArray[row]
    }
}

extension AddDogViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dogImageView.image = info[.editedImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
}



extension AddDogViewController {
    //keyboard setting

    
    func hideKeyboard() {
        dogName.resignFirstResponder()
        dogBreed.resignFirstResponder()
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
        return true
    }
    
}
