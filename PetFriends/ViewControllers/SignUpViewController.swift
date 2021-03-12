//
//  SignUpViewController.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/24/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var dogImageView: UIImageView!
    

    @IBOutlet weak var myDogNameTextField: UITextField!
    @IBOutlet weak var myDogBreedTextField: UITextField!
    @IBOutlet weak var myDogGenderPicker: UIPickerView!
    @IBOutlet weak var myDogBioTextView: UITextView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var LabelAndView: UIView!
    
    
    var design = Design()

    let genderChoiceArray = ["オス", "メス"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogImageView.layer.cornerRadius = 20
        dogImageView.clipsToBounds = true

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barTintColor = design.themeColor
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = design.subColor
        
        design.textFieldDesign(textField: myDogNameTextField)
        myDogNameTextField.delegate = self
        myDogNameTextField.attributedPlaceholder = NSAttributedString(string: "ペットの名前",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        myDogNameTextField.addTarget(self, action: #selector(onExitAction(sender:)), for: .editingDidEndOnExit)
        
        design.textFieldDesign(textField: myDogBreedTextField)
        myDogBreedTextField.delegate = self
        myDogBreedTextField.attributedPlaceholder = NSAttributedString(string: "ペットの犬種",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        myDogBreedTextField.addTarget(self, action: #selector(onExitAction(sender:)), for: .editingDidEndOnExit)
        
//        design.textViewDesign(textView: myDogBioTextView)
        design.ViewDesign(view: LabelAndView)
        
        
        myDogGenderPicker.setValue(UIColor.black, forKey: "textColor")
        
        design.textFieldDesign(textField: emailTextField)
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(onExitAction(sender:)), for: .editingDidEndOnExit)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                
        design.textFieldDesign(textField: passwordTextField)
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(onExitAction(sender:)), for: .editingDidEndOnExit)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    
        signupButton.layer.cornerRadius = 10

        
        myDogGenderPicker.delegate = self
        myDogGenderPicker.dataSource = self
    }
    
    
    
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
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
    
    @IBAction func albumButtonTapped(_ sender: Any) {
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
    
    
    
    func validateFields() -> String? {
        
        if myDogBreedTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || myDogBreedTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "全て記入してください"
        } else {
        return nil
        }
    }
    
    @objc func onExitAction(sender: Any) {
        // textFieldShouldReturn(_:) で `false` を返した場合は呼出されない
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        let errorMessage = validateFields()
        
        
        
        if errorMessage != nil {
            showError(_message: errorMessage!)
        }
        else {
            
            let dogName = myDogNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let dogBreed = myDogBreedTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            var dogGender = Bool()
            if myDogGenderPicker.selectedRow(inComponent: 0) == 0 {
                dogGender = false
            } else {
                dogGender = true
            }
            
            let dogBio = myDogBioTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let myDog = MyDogStruct(name: dogName, breed: dogBreed, gender: dogGender, bio: dogBio)
            
        
            let dogFirebase = DogFirebase()

            dogFirebase.createNewAccount(email: email, password: password, myDog: myDog, view: dogImageView)
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // ここ時間じゃなくす
            
            self.transitionToHome()
        }
    }
    
    
    func showError(_message:String) {
        errorLabel.text = _message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
            let homevc = storyboard?.instantiateViewController(identifier: "TabVC") as? UITabBarController
            view.window?.rootViewController = homevc
            view.window?.makeKeyAndVisible()
    }

}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            dogImageView.image = info[.editedImage] as? UIImage
            dogImageView.isHidden = false
            dismiss(animated: true, completion: nil)

        }
}


extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let genderChoiceArray = ["オス", "メス"]
//
//        let myTitle = NSAttributedString(string: genderChoiceArray[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
//
        return genderChoiceArray[row]
    }
//
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        return NSAttributedString(string: genderChoiceArray[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
//    }
    

}



