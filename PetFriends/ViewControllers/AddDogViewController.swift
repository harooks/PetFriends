//
//  AddFriendViewController.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/24/21.
//

import UIKit
import Firebase

class AddDogViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let userdefualts = UserDefaults.standard
    let choiceArray = ["オス", "メス"]
    
    
    @IBOutlet weak var dogImageView: UIImageView!
    
    @IBOutlet weak var dogName: UITextField!
    
    @IBOutlet weak var dogBreed: UITextField!
    
    @IBOutlet weak var genderPicker: UIPickerView!
    
    @IBOutlet weak var othersTextView: UITextView!
    
    @IBOutlet weak var addDogButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        genderPicker.delegate = self
        genderPicker.dataSource = self
    }
    
    func setupView() {
        
    }
    
    
    @IBAction func addDogButtonTapped(_ sender: Any) {
        saveData()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return choiceArray[row]
    }
    
    
    func saveData() {
        
        //自分が勝手に入れる犬とすでにオーナーが登録してある犬を分ける。
        
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
